module stage_ID (
    input  logic        clk, rst,
    input  logic [1:0]  PcSrc, ExtOp, MemtoReg,
    input  logic        RegWrite_WB,
    input  logic [4:0]  A3_WB,
    input  logic [31:0] Instr_ID,
    input  logic [31:0] pc4_ID,
    // forward
    input  logic [2:0]  Rd1_Fwd_ctr, Rd2_Fwd_ctr,
    // data from other stages
    input  logic [31:0] ALUres_WB, ALUres_MEM, MemRd_WB, pc4_WB, 
    input  logic [31:0] ExtImm_EX, ExtImm_MEM, ExtImm_WB,
    
    output logic [31:0] Address_ID,
    output logic [31:0] ExtImm,
    output logic [31:0] Rd1_Fwd, Rd2_Fwd
);

    logic [31:0] Rd1, Rd2;
    logic [31:0] Wd;
    logic zero;

    // forwarding Mux for Rd1
    always_comb begin
        case (Rd1_Fwd_ctr)
            3'd0: Rd1_Fwd = Rd1;
            3'd1: Rd1_Fwd = ExtImm_EX;
            3'd2: Rd1_Fwd = ExtImm_MEM;
            3'd3: Rd1_Fwd = ALUres_MEM;
            3'd4: Rd1_Fwd = ExtImm_WB;
            3'd5: Rd1_Fwd = ALUres_WB;
            3'd6: Rd1_Fwd = MemRd_WB;
            default: Rd1_Fwd = '0;
        endcase
    end

    // forwarding Mux for Rd2
    always_comb begin
        case (Rd2_Fwd_ctr)
            3'd0: Rd2_Fwd = Rd2;
            3'd1: Rd2_Fwd = ExtImm_EX;
            3'd2: Rd2_Fwd = ExtImm_MEM;
            3'd3: Rd2_Fwd = ALUres_MEM;
            3'd4: Rd2_Fwd = ExtImm_WB;
            3'd5: Rd2_Fwd = ALUres_WB;
            3'd6: Rd2_Fwd = MemRd_WB;
            default: Rd2_Fwd = '0;
        endcase
    end

    // write back data（WB写GPR，所以在这里处理）
    always_comb begin
        case (MemtoReg)
            2'd0: Wd = ALUres_WB;      // 运算结果
            2'd1: Wd = MemRd_WB;       // 读存储器
            2'd2: Wd = pc4_WB + 4;     // jal回写PC+8，pc+4是延迟槽
            2'd3: Wd = ExtImm_WB;      // lui
            default: Wd = '0;
        endcase
    end

    // branch zero check
    assign zero = (Rd1_Fwd == Rd2_Fwd);

    GPR u_GPR (
        .clk(clk), .rst(rst),
        .A1(Instr_ID[25:21]), 
        .A2(Instr_ID[20:16]), 
        .Rd1(Rd1), .Rd2(Rd2),
        .RegWrite(RegWrite_WB),
        .A3(A3_WB), .Wd(Wd)
    );

    NPC u_NPC (
        .pc4_ID(pc4_ID),
        .PcSrc(PcSrc),
        .zero(zero),
        .Instr_ID(Instr_ID),
        .Address_r31(Rd1_Fwd), // jr跳转地址
        .npc(Address_ID)
    );

    EXT u_EXT (
        .Imm(Instr_ID[15:0]),
        .ExtOp(ExtOp),
        .ExtImm(ExtImm)
    );

endmodule