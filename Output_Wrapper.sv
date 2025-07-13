module Counter2bit (input enCnt, reset,izcnt, clk, output logic [1:0] cnt, output Co);
    assign Co = &cnt;
    always @(posedge clk or posedge reset) begin
        if (reset) cnt <= 2'b0;
        else if(izcnt) cnt <= 2'b0;
        else if (enCnt) cnt <= cnt + 1'b1;
    end
endmodule

module Multiplexer4to1(input[1:0] select, input[31:0] in, output logic [7:0] out);
    always @(select, in)begin
            out = 7'b0;
            case(select)
                2'd0:  out = in[31:24];
                2'd1:  out = in[23:16];
                2'd2:  out = in[15:8];
                2'd3:  out = in[7:0];
                default: out = 7'b0;
            endcase
        end  
endmodule

module Buffif1(input [7:0] in, input select, output [7:0] out);
    assign out = select ? in : 8'bzzzzzzzz;
endmodule

module Output_Wrapper_Datapath(input [15:0] Quotient, Remainder, input PutOnBus,encnt,izcnt,reset,clk, output [7:0] out, output Co);
    wire [1:0] cnt;
    Counter2bit counter(.enCnt(encnt), .reset(reset), .izcnt(izcnt), .clk(clk), .cnt(cnt), .Co(Co));
    wire [7:0] multiplexer_output;
    Multiplexer4to1 multiplexer(.select(cnt), .in({Quotient,Remainder}), .out(multiplexer_output));
    Buffif1 buffer(.in(multiplexer_output), .select(PutOnBus), .out(out));
endmodule

module Output_Wrapper_Controller(input Ready,ReceiveData,Co,clk,reset,
            output logic ReadyForInput, OutBuffFull, encnt,izcnt,output PutOnBus);
        typedef enum {A,B,C,D} states;
        states state,next_state;
         always @(posedge clk or posedge reset) begin
            if(reset) state <= A;
            else state <= next_state;
        end
        assign PutOnBus = (Co || (state == C)) ? 1'b1 : 1'b0;
        always @(state, Ready, ReceiveData, Co) begin
        {ReadyForInput, OutBuffFull, encnt, izcnt} = 0;
        case (state)
            A: begin
                ReadyForInput = 1;
                izcnt = 1;
                next_state = Ready ? A : B;
            end
            B: begin
                next_state = Ready ? C : B;
            end
            C: begin
                OutBuffFull = 1;
                next_state = ReceiveData ? D : C;
            end
            D: begin
                encnt = 1;
                next_state = Co ? A : C;
            end
        endcase
    end
endmodule

module Output_Wrapper(input Ready, ReceiveData, reset,clk,input [15:0] Quotient,Remainder,
        output ReadyForInput,OutBuffFull, output [7:0]DataOut);
        wire encnt, izcnt, PutOnBus, Co;
        Output_Wrapper_Datapath Dp(.Quotient(Quotient), .Remainder(Remainder),.encnt(encnt),
            .izcnt(izcnt),.reset(reset),.clk(clk), .PutOnBus(PutOnBus),.out(DataOut), .Co(Co));
        Output_Wrapper_Controller controller(.Ready(Ready), .ReceiveData(ReceiveData), .Co(Co), .clk(clk),
            .reset(reset), .ReadyForInput(ReadyForInput), .OutBuffFull(OutBuffFull),
             .encnt(encnt), .izcnt(izcnt), .PutOnBus(PutOnBus));
endmodule