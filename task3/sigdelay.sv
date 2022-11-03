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
