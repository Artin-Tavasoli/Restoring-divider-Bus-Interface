`timescale 1ns/1ps
module Input_Wrapper_tb;
    reg ReadyForInput, StartData, reset, clk;
    reg [7:0] DataIn;
    wire [15:0] Dividend, Diviser;
    wire ReadyToAccept, Start;
    Input_Wrapper dut (
        .ReadyForInput(ReadyForInput),
        .StartData(StartData),
        .reset(reset),
        .clk(clk),
        .DataIn(DataIn),
        .Dividend(Dividend),
        .Diviser(Diviser),
        .ReadyToAccept(ReadyToAccept),
        .Start(Start)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        ReadyForInput = 0; StartData = 0; reset = 1; DataIn = 8'h00;
        #10 reset = 0;

        ReadyForInput = 1; StartData = 1; DataIn = 8'hAA;
        #10;
        wait (ReadyToAccept == 1);
        StartData = 0; #20;

        StartData = 1; DataIn = 8'hBB;
        #10; 
        wait (ReadyToAccept == 1);
        StartData = 0; #20;

        StartData = 1; DataIn = 8'hCC;
        #10;
        wait (ReadyToAccept == 1);
        StartData = 0; #20;

        StartData = 1; DataIn = 8'hDD;
        #10;
        wait (ReadyToAccept == 1);
        StartData = 0; #20;
        $stop;
    end
endmodule
