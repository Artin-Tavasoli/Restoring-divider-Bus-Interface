module Left_Shift_Register (input [15:0] in, input clk, load, reset, lshift, Sin, output logic [15:0] out, output Sout);
    assign Sout = out[15];
    always @(posedge clk or posedge reset) begin
        if (reset) out <= 16'b0;
        else if (load) out <= in;
        else if (lshift) out <= {out[14:0], Sin};
        $display("Left_Shift_Register: in = %b, out = %b", in, out);
    end
endmodule