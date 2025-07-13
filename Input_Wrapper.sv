module Counter2bit (input enCnt, reset,izcnt, clk, output logic [1:0] cnt, output Co);
    assign Co = &cnt;
    always @(posedge clk or posedge reset) begin
        if (reset) cnt <= 2'b0;
        else if(izcnt) cnt <= 2'b0;
        else if (enCnt) cnt <= cnt + 1'b1;
    end
endmodule

module Dcd2to4 (input en,reset, input [1:0] in, output logic[3:0] out);
    always @(reset, en, in)begin
        out = 4'b0;
        if (reset)  out = 4'b0;
        else if(en)begin
            case(in)
                2'd0:  out = 4'b0001;
                2'd1:  out = 4'b0010;
                2'd2:  out = 4'b0100;
                2'd3:  out = 4'b1000;
                default: out = 4'b0;
            endcase
        end
        else  out = 4'b0;
    end                          
endmodule

module Register8bit (input [7:0] in, input clk, load, reset, output logic [7:0] out);
    always @(posedge clk or posedge reset) begin
        if (reset) out <= 8'b0;
        else if (load) out <= in;
    end
endmodule

module Input_Wrapper_Datapath(input encnt,izcnt,reset,load,clk, input [7:0]DataIn, 
        output [15:0] Dividend,Diviser, output Co);
    wire [1:0] cnt;
    Counter2bit counter(.enCnt(encnt), .reset(reset), .izcnt(izcnt), .clk(clk), .cnt(cnt), .Co(Co));
    wire [3:0] registers_load;
    Dcd2to4 dcd(.en(load), .reset(reset), .in(cnt), .out(registers_load));
    wire [7:0] Dividend_8bitMS, Dividend_8bitLS, Diviser_8bitMS, Diviser_8bitLS;   
    Register8bit rg1(.in(DataIn), .clk(clk), .load(registers_load[0]), .reset(reset), .out(Dividend_8bitMS));
    Register8bit rg2(.in(DataIn), .clk(clk), .load(registers_load[1]), .reset(reset), .out(Dividend_8bitLS));
    Register8bit rg3(.in(DataIn), .clk(clk), .load(registers_load[2]), .reset(reset), .out(Diviser_8bitMS));
    Register8bit rg4(.in(DataIn), .clk(clk), .load(registers_load[3]), .reset(reset), .out(Diviser_8bitLS));
    assign Dividend = {Dividend_8bitMS, Dividend_8bitLS};
    assign Diviser = {Diviser_8bitMS, Diviser_8bitLS};
endmodule

module Input_Wrapper_Controller(input ReadyForInput,StartData,Co,clk,reset,
            output logic ReadyToAccept, Start, encnt,izcnt, output load);
        typedef enum {A,B,C,D,E} states;
        states state,next_state;
        always @(posedge clk or posedge reset) begin
            if(reset) state <= A;
            else state <= next_state;
        end
        assign load = (Co || (state == B)) ? 1'b1 : 1'b0;
        always @(state, StartData, Co, ReadyForInput) begin
        {ReadyToAccept, encnt, Start, izcnt} = 0;
        //next_state = state;
        case (state)
            A: begin
                next_state = StartData ? B : A;
                ReadyToAccept = 1;
            end
            B: begin
                next_state = C;
            end
            C: begin
                encnt = 1;
                next_state = Co ? D : A;
            end
            D: begin
                next_state = ReadyForInput ? E : D;
            end
            E: begin
                Start = 1;
                izcnt = 1;
                next_state = A;
            end
        endcase
    end
endmodule



module Input_Wrapper(input ReadyForInput,StartData, reset,clk, input [7:0]DataIn, 
        output [15:0] Dividend,Diviser, output ReadyToAccept, Start);
        
        wire encnt, izcnt, load, Co;
        Input_Wrapper_Datapath Dp(.encnt(encnt), .izcnt(izcnt), .reset(reset), .load(load), .clk(clk),
                    .DataIn(DataIn), .Dividend(Dividend), .Diviser(Diviser), .Co(Co));

        Input_Wrapper_Controller controller(.ReadyForInput(ReadyForInput), .StartData(StartData), .Co(Co), .clk(clk), .reset(reset),
         .ReadyToAccept(ReadyToAccept), .Start(Start), .encnt(encnt), .izcnt(izcnt), .load(load));
endmodule