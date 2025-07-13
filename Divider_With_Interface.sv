module Divider_With_Interface(input StartData, reset, clk, ReceiveData,  input [7:0]DataIn,
    output ReadyToAccept, Valid, OutBuffFull, output [7:0]DataOut);
    wire ReadyForInput, Start, Ready;
    wire [15:0]Dividend, Divisor, Quotient, Remainder;
    Input_Wrapper input_wrapper(.ReadyForInput(ReadyForInput), .StartData(StartData), .clk(clk), .reset(reset),
    .DataIn(DataIn), .Dividend(Dividend), .Diviser(Divisor), .ReadyToAccept(ReadyToAccept), .Start(Start));
    Divider divider(.Dividend(Dividend), .Divisor(Divisor), .clk(clk), .start(Start),
    .rst(reset), .R(Remainder), .Q(Quotient), .ready(Ready), .valid(Valid));
    Output_Wrapper output_wrapper(.Ready(Ready), .ReceiveData(ReceiveData), .reset(reset), .clk(clk),
    .Quotient(Quotient), .Remainder(Remainder), .ReadyForInput(ReadyForInput), .OutBuffFull(OutBuffFull), .DataOut(DataOut));
endmodule