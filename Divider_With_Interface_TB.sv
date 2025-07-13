`timescale 1ns/1ps

module Divider_With_Interface_tb;
    reg StartData, reset, clk, ReceiveData, ReadyForInput;
    reg [7:0] DataIn;
    wire ReadyToAccept, Valid, OutBuffFull;
    wire [7:0] DataOut;
    
    Divider_With_Interface DUT (
        .StartData(StartData),
        .reset(reset),
        .clk(clk),
        .ReceiveData(ReceiveData),
        .DataIn(DataIn),
        .ReadyToAccept(ReadyToAccept),
        .Valid(Valid),
        .OutBuffFull(OutBuffFull),
        .DataOut(DataOut)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        ReadyForInput = 0; StartData = 0; reset = 1; DataIn = 8'b0;
        #10 reset = 0;
        ReceiveData = 0;

        ReadyForInput = 1; StartData = 1; DataIn = 8'b01010110;
        #10;
        wait (ReadyToAccept == 1);
        StartData = 0; #20;

        StartData = 1; DataIn = 8'b10011101;
        #10; 
        wait (ReadyToAccept == 1);
        StartData = 0; #20;

        StartData = 1; DataIn = 8'b00000101;
        #10;
        wait (ReadyToAccept == 1);
        StartData = 0; #20;

        StartData = 1; DataIn = 8'b10000101;
        #10;
        wait (ReadyToAccept == 1);
        StartData = 0;
        #50;
        
        repeat (4) begin
            wait(OutBuffFull);
            ReceiveData = 1;
            #20;
            ReceiveData = 0;
            #20;
        end
        
        #50;
        $stop;
    end
endmodule
