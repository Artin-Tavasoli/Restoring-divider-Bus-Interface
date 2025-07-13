module Controller(
    input clk,
    input start,
    input rst_cnt,
    input SB, error_divided_0,
    output logic ready,
    output logic LdA, LdB, LdTemp, LsftA, LsftTemp
    );
    parameter [1:0] Idle = 2'd0, Starting = 2'd1, Loading = 2'd2, Calculating = 2'd3;
    logic [1:0] state, next_state;
    initial begin
        state = Idle;
    end
    wire Co;
    logic en_cnt;
    wire [3:0] cnt;
    Counter count_module(.enCnt(en_cnt), .reset(rst_cnt), .clk(clk), .cnt(cnt), .Co(Co));

    always @(posedge clk) begin
        state <= next_state;
        $display("Controller state: %d", state);
    end

    always @(*) begin
        {ready, LdA, LdB, LdTemp, LsftA, LsftTemp, en_cnt} = 0;
        next_state = state;
        case (state)
            Idle: begin
                ready = 1;
                if (start) next_state = Starting;
                else next_state = Idle;
            end
            Starting: begin
                if (!start) next_state = Loading;
                else next_state = Starting;
            end
            Loading: begin
                LdA = 1;
                LdB = 1;
                next_state = error_divided_0 ? Idle : Calculating;
            end
            Calculating: begin
                en_cnt = 1;
                LsftA = 1;
                LsftTemp = SB;
                LdTemp = ~SB;
                next_state = Co ? Idle : Calculating;
            end
        endcase
    end
endmodule
