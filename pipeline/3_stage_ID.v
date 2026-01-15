`include "./datapath/NPC.v"
`include "./datapath/GPR.v"
`include "./datapath/EXT.v"
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
    output [31:0] Rd1_Fwd, Rd2_Fwd
);
    wire zero;
    wire [31:0] Rd1, Rd2;
    assign Rd1_Fwd = (Rd1_Fwd_ctr == 0)?Rd1:
                     (Rd1_Fwd_ctr == 1)?ExtImm_EX:
                     (Rd1_Fwd_ctr == 2)?ExtImm_MEM:
                     (Rd1_Fwd_ctr == 3)?ALUres_MEM:
                     (Rd1_Fwd_ctr == 4)?ExtImm_WB:
                     (Rd1_Fwd_ctr == 5)?ALUres_WB:
                     (Rd1_Fwd_ctr == 6)?MemRd_WB:0;

    assign Rd2_Fwd = (Rd2_Fwd_ctr == 0)?Rd2:
                     (Rd2_Fwd_ctr == 1)?ExtImm_EX:
                     (Rd2_Fwd_ctr == 2)?ExtImm_MEM:
                     (Rd2_Fwd_ctr == 3)?ALUres_MEM:
                     (Rd2_Fwd_ctr == 4)?ExtImm_WB:
                     (Rd2_Fwd_ctr == 5)?ALUres_WB:
                     (Rd2_Fwd_ctr == 6)?MemRd_WB:0;
    // jal往r31里写pc4，可能会预取r31，所以这里应该加上pc4_EX~WB+4（pc+8）
    // 我的测试指令避免读r31，所以忽略了这种情况
    wire [31:0] Wd;
    assign Wd = (MemtoReg == 0) ? ALUres_WB :
                (MemtoReg == 1) ? MemRd_WB :
                (MemtoReg == 2) ? pc4_WB + 4 :
                (MemtoReg == 3) ? ExtImm_WB : 0;
                // 0:运算结果 1:读存储器 2:PC+8 3:lui
                // 回写pc+8，pc+4是延迟槽，是编译预取的不相关指令
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