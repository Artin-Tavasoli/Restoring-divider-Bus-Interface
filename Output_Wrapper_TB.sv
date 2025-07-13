`timescale 1ns/1ps
module Output_Wrapper_tb;

    reg Ready, ReceiveData, reset, clk;
    reg [15:0] Quotient, Remainder;
    wire ReadyForInput, OutBuffFull;
    wire [7:0] DataOut;

    Output_Wrapper dut (
        .Ready(Ready),
        .ReceiveData(ReceiveData),
        .reset(reset),
        .clk(clk),
        .Quotient(Quotient),
        .Remainder(Remainder),
        .ReadyForInput(ReadyForInput),
        .OutBuffFull(OutBuffFull),
        .DataOut(DataOut)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        Ready = 0; ReceiveData = 1; reset = 1;
        Quotient = 16'h1234; Remainder = 16'hABCD;
        #10 reset = 0;
        Ready = 1; #20;
        Ready = 0;
        wait(ReadyForInput == 1);#50;
        $stop;
    end
endmodule
