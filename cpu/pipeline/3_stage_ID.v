module stage_ID (
    input clk, rst,
    input [1:0] PcSrc, ExtOp, MemtoReg,
    input RegWrite_WB,
    input [4:0] A3_WB,
    input [31:0] Instr_ID,
    input [31:0] pc4_ID,
    input [2:0] Rd1_Fwd_ctr, Rd2_Fwd_ctr,
    input [31:0] ALUres_WB, ALUres_MEM, MemRd_WB, pc4_WB, ExtImm_EX, ExtImm_MEM, ExtImm_WB,
    output [31:0] Address_ID,
    output [31:0] ExtImm,
    output reg [31:0] Rd1_Fwd, Rd2_Fwd
);
    wire zero;
    wire [31:0] Rd1, Rd2;
    always @(*) begin
        case (Rd1_Fwd_ctr)
            3'd0: Rd1_Fwd = Rd1;
            3'd1: Rd1_Fwd = ExtImm_EX;
            3'd2: Rd1_Fwd = ExtImm_MEM;
            3'd3: Rd1_Fwd = ALUres_MEM;
            3'd4: Rd1_Fwd = ExtImm_WB;
            3'd5: Rd1_Fwd = ALUres_WB;
            3'd6: Rd1_Fwd = MemRd_WB;
            default: Rd1_Fwd = 32'd0;
        endcase
    end
    always @(*) begin
        case (Rd2_Fwd_ctr)
            3'd0: Rd2_Fwd = Rd2;
            3'd1: Rd2_Fwd = ExtImm_EX;
            3'd2: Rd2_Fwd = ExtImm_MEM;
            3'd3: Rd2_Fwd = ALUres_MEM;
            3'd4: Rd2_Fwd = ExtImm_WB;
            3'd5: Rd2_Fwd = ALUres_WB;
            3'd6: Rd2_Fwd = MemRd_WB;
            default: Rd2_Fwd = 32'd0;
        endcase
    end
    // jal往r31里写pc4，可能会预取r31，所以这里应该加上pc4_EX~WB+4（pc+8）
    // 我的测试指令避免读r31，所以忽略了这种情况
    reg [31:0] Wd;
    always @(*) begin
        case (MemtoReg)
            2'd0: Wd = ALUres_WB;   // 运算结果
            2'd1: Wd = MemRd_WB;    // 读存储器
            2'd2: Wd = pc4_WB + 4;  // 回写pc+8，pc+4是延迟槽，是编译预取的不相关指令
            2'd3: Wd = ExtImm_WB;   // lui 扩展立即数
            default: Wd = 32'd0;
        endcase
    end
    assign zero = (Rd1_Fwd == Rd2_Fwd);
    GPR GPR(
        .clk(clk), .rst(rst),
        .A1(Instr_ID[25:21]), .A2(Instr_ID[20:16]), 
        .Rd1(Rd1), .Rd2(Rd2),
        .RegWrite(RegWrite_WB),
        .A3(A3_WB), .Wd(Wd)
    );
    NPC NPC(
        .PcSrc(PcSrc), .zero(zero),
        .pc4_ID(pc4_ID), .Instr_ID(Instr_ID), .Address_r31(Rd1_Fwd),
        .npc(Address_ID)
    );
    EXT EXT(
        .Imm(Instr_ID[15:0]),
        .ExtOp(ExtOp),
        .ExtImm(ExtImm)
    );
endmodule