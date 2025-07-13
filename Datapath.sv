module Datapath(input [15:0] A, B, input clk, reset, LdA, LdB, LdTemp, LsftA, LsftTemp,
                output [15:0] Q, R, output SB, error_divided_0);
    wire [15:0] absA, absB, i, j, k, p, q;
    wire s;
    assign error_divided_0 = ~|B;
    assign SB = k[15];
    assign Q = q;
    assign R = p;

    Absolute Aabs(.in(A), .out(absA));
    Absolute Babs(.in(B), .out(absB));

    Register Breg(
        .in(absB), 
        .clk(clk), 
        .load(LdB), 
        .reset(reset), 
        .out(j)
    );

    Left_Shift_Register Areg(
        .in(absA), 
        .clk(clk),
        .load(LdA),
        .reset(reset),
        .lshift(LsftA),
        .Sin(~SB),
        .out(q),
        .Sout(s)
    );

    assign i = {p[14:0], q[15]};

    wire temp_reg_sout;
    Left_Shift_Register Temp_reg(
        .in(k), 
        .clk(clk),
        .load(LdTemp),
        .reset(reset),
        .lshift(LsftTemp),
        .Sin(s),
        .out(p),
        .Sout(temp_reg_sout)
    );

    Subtract sub(.num1(i), .num2(j), .out(k));
endmodule