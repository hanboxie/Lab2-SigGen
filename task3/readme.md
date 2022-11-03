# Task 3 - Capture and display audio signal in RAM

## Step 1 - Create 512 x 8 bit dual-port RAM component
```systemverilog
module ram #(
    parameter   ADDRESS_WIDTH = 9,
                DATA_WIDTH = 8
)(
    input logic clk,
    input logic wr, //read and write enablers
    input logic rd,
    input logic [ADDRESS_WIDTH-1:0] wr_addr,
    input logic [ADDRESS_WIDTH-1:0] rd_addr,
    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout
);

logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

always_ff @(posedge clk) begin
    if (wr == 1'b1)
        ram_array[wr_addr] <= din;  //write value to ram address
    if (rd == 1'b1)
        dout <= ram_array[rd_addr]; //read value from ram address
end
endmodule
```

## Step 2 - Adjust counter
```systemverilog
module counter #(
    parameter WIDTH = 9 //new width
)(
    //interface signals
    input logic     clk,            //clock
    input logic     rst,            //reset
    output logic [WIDTH-1:0] count  //count output
);

always_ff @ (posedge clk)
    if (rst) count <= {WIDTH{1'b0}};
    else count <= count + 1; //constantly increment address by 1

endmodule
```

## Step 2 - Combine with a top-level module
```systemverilog
module sigdelay #(
        parameter A_WIDTH = 9,
                  D_WIDTH = 8
) (
    input logic        clk,
    input logic        rst,
    input logic        wr,
    input logic        rd,
    input logic [A_WIDTH-1:0] offset,
    input logic [D_WIDTH-1:0] mic_signal,
    output logic [D_WIDTH-1:0] delayed_signal
);

    logic [A_WIDTH-1:0] address;

counter addrCounter (
    .clk (clk),
    .rst (rst),
    .count (address)
);

ram sigRam(
    .clk (clk),
    .wr(wr),
    .rd(rd),
    .rd_addr (address),
    .wr_addr (address+offset),
    .dout (delayed_signal),
    .din (mic_signal)
);

endmodule
```

## Step 3 - Compile and test
Testbench is provided already, no major changes.