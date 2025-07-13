module Register (input [15:0] in, input clk, load, reset, output logic [15:0] out);
    always @(posedge clk or posedge reset) begin
        if (reset) out <= 16'b0;
        else if (load) out <= in;
        $display("Register: in = %b, out = %b", in, out);
    end
endmodule