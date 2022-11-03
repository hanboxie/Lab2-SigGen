# Task 2 - Sine and Cosine Dual wave generation

## Step 1 - Modify rom.sv for 2 inputs

```systemverilog
module rom #(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 8
)(
    input logic clk,
    input logic [ADDRESS_WIDTH-1:0] addr1,
    input logic [ADDRESS_WIDTH-1:0] addr2, // new address
    output logic [DATA_WIDTH-1:0] dout1,
    output logic [DATA_WIDTH-1:0] dout2 // new output
);

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("Loading rom.");
        $readmemh("sinerom.mem", rom_array);
end;

always_ff @(posedge clk) begin
    //output is synchronous
    dout1 <= rom_array [addr1];
    dout2 <= rom_array [addr2]; // new output
end

endmodule
```

## Step 2 - Modify sinegen.sv

```systemverilog
module sinegen #(
        parameter A_WIDTH = 8,
                  D_WIDTH = 8
) (
    input logic        clk,
    input logic        rst,
    input logic        en,
    input logic [D_WIDTH-1:0] incr, 
    input logic [D_WIDTH-1:0] offset, // new input
    output logic [D_WIDTH-1:0] dout1,
    output logic [D_WIDTH-1:0] dout2 // new output

);

    logic [A_WIDTH-1:0] address;

// counter stays the same
counter addrCounter (
    .clk (clk),
    .rst (rst),
    .en (en),
    .incr (incr),
    .count (address)
);

// the rom is changed
rom sineRom(
    .clk (clk),
    .addr1 (address),
    .addr2 (address+offset),
    .dout1 (dout1),
    .dout2 (dout2)
);

endmodule
```
## Step 3 - Counter.sv
Counter.sv is the same. top->incr is dictated in the testbench cpp file.

## Step 4 - Modify testbench

New output code
```cpp
    top->offset = vbdValue(); //offset value
    // plot ROM output and print cycle count
    vbdPlot(int (top->dout1), 0, 255);
    vbdPlot(int (top->dout2), 0, 255);
    vbdCycle(simcyc);
```

## Step 5 - Offset Value

For a constant offset value, we simply change the sineRom module in sinegen.sv
```systemverilog
rom sineRom(
    .clk (clk),
    .addr1 (address),
    .addr2 (address+64),
    .dout1 (dout1),
    .dout2 (dout2)
);
```
Note: since 360 degrees = 256 addresses, 64 addresses would be 90 degrees.