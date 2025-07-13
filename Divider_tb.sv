`timescale 1ns/1ns
module tb_Divider;
    logic [15:0] Dividend, Divisor;
    logic clk, start, rst;
    wire [15:0] R, Q;
    wire ready, valid;

    Divider uut (
        .Dividend(Dividend),
        .Divisor(Divisor),
        .clk(clk),
        .start(start),
        .rst(rst),
        .R(R),
        .Q(Q),
        .ready(ready),
        .valid(valid)
    );
    initial begin
        clk = 0;
        forever #15 clk = ~clk;
    end

    initial begin
        rst = 0;
        start = 0;
        Dividend = 16'b0;
        Divisor = 16'b0;

        // Test case 1: 1403 ÷ 11
        rst = 1; #50; rst = 0;
        Dividend = 16'd1403;
        Divisor = 16'd11;
        start = 1; #50; start = 0;
        wait(ready == 1);
        #10;

        // Test case 2: 10 ÷ 0 (error case)
        rst = 1; #50; rst = 0;
        Dividend = 16'd10;
        Divisor = 16'd0;
        start = 1; #50; start = 0;
        wait(ready == 1);
        #10;

        // Test case 3: 15 ÷ 3
        rst = 1; #50; rst = 0;
        Dividend = 16'd15;
        Divisor = 16'd3;
        start = 1; #50; start = 0;
        wait(ready == 1);
        #10;

        // Test case 4: -7 ÷ -3 
        rst = 1; #50; rst = 0;
        Dividend = 16'b1111111111111111111111111111111111111111111111111111111111111001; // 2's comp of -7
        Divisor = 16'b1111111111111111111111111111111111111111111111111111111111111101; // 2's comp of -3
        start = 1; #50; start = 0;
        wait(ready == 1);
        #10;


        $stop;
    end
endmodule
