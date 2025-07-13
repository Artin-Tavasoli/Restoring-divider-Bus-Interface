module Divider(
    input [15:0] Dividend, Divisor,
    input clk, start,
    input rst,
    output [15:0] R, Q,
    output ready,
    output valid
    );
    wire LdA, LdB, LdTemp, LsftA, LsftTemp;
    wire SB, error_divided_0;
    assign valid = ~error_divided_0;

    Datapath datapath_module(
        .A(Dividend),
        .B(Divisor),
        .clk(clk), 
        .reset(rst), 
        .LdA(LdA), 
        .LdB(LdB), 
        .LdTemp(LdTemp),
        .LsftA(LsftA),
        .LsftTemp(LsftTemp),
        .Q(Q),
        .R(R),
        .SB(SB),
        .error_divided_0(error_divided_0)
    );

    Controller controller_module(
        .clk(clk),
        .start(start),
        .rst_cnt(rst),
        .SB(SB),
        .error_divided_0(error_divided_0),
        .ready(ready),
        .LdA(LdA), 
        .LdB(LdB),
        .LdTemp(LdTemp), 
        .LsftA(LsftA), 
        .LsftTemp(LsftTemp)
    );
endmodule
