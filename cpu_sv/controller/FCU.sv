module FCU (
    input  logic [4:0] A1_ID, A1_EX,
    input  logic [4:0] A2_ID, A2_EX, A2_MEM,
    input  logic [4:0] A3_ID, A3_EX, A3_MEM, A3_WB,
    input  logic [1:0] Tnew_EX, Tnew_MEM, Tnew_WB,
    output logic [1:0] MemWd_Fwd_ctr,
    output logic [2:0] ALUa_Fwd_ctr, ALUb_Fwd_ctr,
    output logic [2:0] Rd1_Fwd_ctr, Rd2_Fwd_ctr
);

    always_comb begin
        // Rd1(Stage ID)
        Rd1_Fwd_ctr = 3'd0;
        if (A1_ID != 0) begin
            if (A1_ID == A3_EX) begin
                if (Tnew_EX == 0) Rd1_Fwd_ctr = 3'd1; // from EX(lui/jal)
            end
            else if (A1_ID == A3_MEM) begin
                if (Tnew_MEM == 0)      Rd1_Fwd_ctr = 3'd2; // from MEM
                else if (Tnew_MEM == 1) Rd1_Fwd_ctr = 3'd3; // ALUres from MEM
            end
            else if (A1_ID == A3_WB) begin
                if (Tnew_WB == 0)       Rd1_Fwd_ctr = 3'd4; // from WB
                else if (Tnew_WB == 1)  Rd1_Fwd_ctr = 3'd5;
                else if (Tnew_WB == 2)  Rd1_Fwd_ctr = 3'd6;
            end
        end

        // Rd2(Stage ID)
        Rd2_Fwd_ctr = 3'd0;
        if (A2_ID != 0) begin
            if (A2_ID == A3_EX) begin
                if (Tnew_EX == 0) Rd2_Fwd_ctr = 3'd1;
            end
            else if (A2_ID == A3_MEM) begin
                if (Tnew_MEM == 0)      Rd2_Fwd_ctr = 3'd2;
                else if (Tnew_MEM == 1) Rd2_Fwd_ctr = 3'd3;
            end
            else if (A2_ID == A3_WB) begin
                if (Tnew_WB == 0)       Rd2_Fwd_ctr = 3'd4;
                else if (Tnew_WB == 1)  Rd2_Fwd_ctr = 3'd5;
                else if (Tnew_WB == 2)  Rd2_Fwd_ctr = 3'd6;
            end
        end

        // ALUa(Stage EX)
        ALUa_Fwd_ctr = 3'd0;
        if (A1_EX != 0) begin
            if (A1_EX == A3_MEM) begin
                if (Tnew_MEM == 0)      ALUa_Fwd_ctr = 3'd1;
                else if (Tnew_MEM == 1) ALUa_Fwd_ctr = 3'd2; // ALUres from MEM
            end
            else if (A1_EX == A3_WB) begin
                if (Tnew_WB == 0)       ALUa_Fwd_ctr = 3'd3;
                else if (Tnew_WB == 1)  ALUa_Fwd_ctr = 3'd4;
                else if (Tnew_WB == 2)  ALUa_Fwd_ctr = 3'd5;
            end
        end

        // ALUb(Stage EX)
        ALUb_Fwd_ctr = 3'd0;
        if (A2_EX != 0) begin
            if (A2_EX == A3_MEM) begin
                if (Tnew_MEM == 0)      ALUb_Fwd_ctr = 3'd1;
                else if (Tnew_MEM == 1) ALUb_Fwd_ctr = 3'd2;
            end
            else if (A2_EX == A3_WB) begin
                if (Tnew_WB == 0)       ALUb_Fwd_ctr = 3'd3;
                else if (Tnew_WB == 1)  ALUb_Fwd_ctr = 3'd4;
                else if (Tnew_WB == 2)  ALUb_Fwd_ctr = 3'd5;
            end
        end

        // Mem write data(Stage MEM)
        MemWd_Fwd_ctr = 2'd0;
        if (A2_MEM != 0) begin
            if (A2_MEM == A3_WB) begin
                if (Tnew_WB == 0)      MemWd_Fwd_ctr = 2'd1;
                else if (Tnew_WB == 1) MemWd_Fwd_ctr = 2'd2;
                else if (Tnew_WB == 2) MemWd_Fwd_ctr = 2'd3;
            end
        end
    end

endmodule