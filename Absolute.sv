module Absolute(input [15:0] in, output [15:0] out);
    assign out = in[15] ? (~in + 1) : in;
endmodule