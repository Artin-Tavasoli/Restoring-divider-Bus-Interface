module Counter (input enCnt, reset, clk, output logic [3:0] cnt, output Co);
    assign Co = &cnt;
    always @(posedge clk or posedge reset) begin
        if (reset) cnt <= 4'b0;
        else if (enCnt) cnt <= cnt + 1;
        $display("Counter: enCnt = %b, reset = %b, cnt = %d", enCnt, reset, cnt);
    end
endmodule