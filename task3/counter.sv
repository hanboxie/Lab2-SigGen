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
