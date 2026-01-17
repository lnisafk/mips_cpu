import mips_pkg::*;

module mips (
    input logic clk, rst
);
    // Pipeline Regs Data
    logic [31:0] Instr_IF, Instr_ID, Instr_EX, Instr_MEM;
    logic [31:0] pc4_IF, pc4_ID, pc4_EX, pc4_MEM, pc4_WB;
    logic [31:0] MemRd_MEM, MemRd_WB;
    logic [31:0] MemWd_EX, MemWd_MEM; 
    logic [31:0] ALUres_EX, ALUres_MEM, ALUres_WB;
    logic [31:0] Address_ID;
    logic [31:0] ExtImm_ID, ExtImm_EX, ExtImm_MEM, ExtImm_WB;
    
    // Reg Addr
    logic [4:0] A1_ID, A1_EX;
    logic [4:0] A2_ID, A2_EX, A2_MEM;
    logic [4:0] A3_ID, A3_EX, A3_MEM, A3_WB;
    
    // forward
    logic [1:0] MemWd_Fwd_ctr;
    logic [2:0] ALUa_Fwd_ctr, ALUb_Fwd_ctr;
    logic [2:0] Rd1_Fwd_ctr, Rd2_Fwd_ctr;
    logic [31:0] Rd1_Fwd, Rd2_Fwd;
    logic [31:0] Rd1_EX, Rd2_EX;
    
    // hazard
    logic stall;
    logic mem_stall_MEM;
    logic [1:0] Tnew_ID, Tnew_EX, Tnew_MEM, Tnew_WB;
    logic Tuse_rs;
    logic [1:0] Tuse_rt;
    logic cal_ID, load_ID, cal_EX, load_EX, load_MEM;

    // Control
    logic RegWrite_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB;
    logic MemWrite_ID, MemWrite_EX, MemWrite_MEM;
    logic ALUsrc_ID, ALUsrc_EX;
    logic [1:0] PcSrc, ExtOp;
    logic [1:0] MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB;
    // ALU Control
    alu_op_t ALUctr_ID, ALUctr_EX;

    // Decoded
    logic addu, subu, ori, lw, sw, beq, lui;
    logic addi, addiu, slt, j, jal, jr;

    Stage_IF IF(
        .clk(clk), .rst(rst),
        .PcSrc(PcSrc), .stall(stall),
        .Address_ID(Address_ID), 
        .Instr_IF(Instr_IF), .pc4_IF(pc4_IF)
    );

    IFID IFID(
        .clk(clk), .rst(rst), .stall(stall),
        .pc4_IF(pc4_IF), .Instr_IF(Instr_IF),
        .pc4_ID(pc4_ID), .Instr_ID(Instr_ID)
    );

    stage_ID ID(
        .clk(clk), .rst(rst), .PcSrc(PcSrc), .ExtOp(ExtOp),
        .Instr_ID(Instr_ID), .pc4_ID(pc4_ID),
        .Rd1_Fwd_ctr(Rd1_Fwd_ctr), .Rd2_Fwd_ctr(Rd2_Fwd_ctr),
        .ALUres_MEM(ALUres_MEM), .ALUres_WB(ALUres_WB),
        .MemRd_WB(MemRd_WB), .pc4_WB(pc4_WB), 
        .ExtImm_EX(ExtImm_EX), .ExtImm_MEM(ExtImm_MEM), .ExtImm_WB(ExtImm_WB),
        .Address_ID(Address_ID), .ExtImm(ExtImm_ID),
        .Rd1_Fwd(Rd1_Fwd), .Rd2_Fwd(Rd2_Fwd),
        .RegWrite_WB(RegWrite_WB), .MemtoReg(MemtoReg_WB),
        .A3_WB(A3_WB)
    );

    IDEX IDEX(
        .clk(clk), .rst(rst), .stall(stall), .mem_stall(mem_stall_MEM),
        .Rd1_ID(Rd1_Fwd), .Rd2_ID(Rd2_Fwd), .ExtImm_ID(ExtImm_ID),
        .pc4_ID(pc4_ID), .Instr_ID(Instr_ID),
        .A3_ID(A3_ID), .A2_ID(A2_ID), .A1_ID(A1_ID),
        .Tnew_ID(Tnew_ID), .MemtoReg_ID(MemtoReg_ID),
        .cal_ID(cal_ID), .load_ID(load_ID),
        .ALUsrc_ID(ALUsrc_ID), .RegWrite_ID(RegWrite_ID), .MemWrite_ID(MemWrite_ID),
        .ALUctr_ID(ALUctr_ID),
        
        .Rd1_EX(Rd1_EX), .Rd2_EX(Rd2_EX), .ExtImm_EX(ExtImm_EX),
        .pc4_EX(pc4_EX), .Instr_EX(Instr_EX),
        .A3_EX(A3_EX), .A2_EX(A2_EX), .A1_EX(A1_EX),
        .Tnew_EX(Tnew_EX), .MemtoReg_EX(MemtoReg_EX),
        .cal_EX(cal_EX), .load_EX(load_EX),
        .ALUsrc_EX(ALUsrc_EX), .RegWrite_EX(RegWrite_EX), .MemWrite_EX(MemWrite_EX),
        .ALUctr_EX(ALUctr_EX)
    );

    Stage_EX EX(
        .Instr_EX(Instr_EX), 
        .ALUa_Fwd_ctr(ALUa_Fwd_ctr), .ALUb_Fwd_ctr(ALUb_Fwd_ctr), 
        .ALUres_MEM(ALUres_MEM), .ALUres_WB(ALUres_WB), .MemRd_WB(MemRd_WB),
        .Rd1(Rd1_EX), .Rd2(Rd2_EX), .ExtImm(ExtImm_EX), .ExtImm_WB(ExtImm_WB), .ExtImm_MEM(ExtImm_MEM),
        .ALUctr(ALUctr_EX), .ALUsrc(ALUsrc_EX),
        .ALUres(ALUres_EX), .ALUb_Fwd(MemWd_EX) // 可能要用A2内容写Mem
    );

    EXMEM EXMEM(
        .clk(clk), .rst(rst), .stall(mem_stall_MEM),
        .MemWd_EX(MemWd_EX), .ALUres_EX(ALUres_EX), .pc4_EX(pc4_EX),
        .MemtoReg_EX(MemtoReg_EX), .Tnew_EX(Tnew_EX), .load_EX(load_EX), 
        .RegWrite_EX(RegWrite_EX), .MemWrite_EX(MemWrite_EX),
        .A2_EX(A2_EX), .A3_EX(A3_EX), .ExtImm_EX(ExtImm_EX),
        
        .MemWd_MEM(MemWd_MEM), .ALUres_MEM(ALUres_MEM), .pc4_MEM(pc4_MEM),
        .MemtoReg_MEM(MemtoReg_MEM), .Tnew_MEM(Tnew_MEM), .load_MEM(load_MEM),
        .RegWrite_MEM(RegWrite_MEM), .MemWrite_MEM(MemWrite_MEM),
        .A2_MEM(A2_MEM), .A3_MEM(A3_MEM), .ExtImm_MEM(ExtImm_MEM)
    );

    Stage_MEM MEM(
        .clk(clk), .rst(rst),
        .MemWd(MemWd_MEM), .ALUres_MEM(ALUres_MEM),
        .ALUres_WB(ALUres_WB), .MemRd_WB(MemRd_WB), .ExtImm_WB(ExtImm_WB),
        .MemtoReg(MemtoReg_MEM),
        .MemWrite(MemWrite_MEM), .MemWd_Fwd_ctr(MemWd_Fwd_ctr),
        .MemRd(MemRd_MEM),
        .mem_stall(mem_stall_MEM)
    );

    MEMWB MEMWB(
        .clk(clk), .rst(rst), .stall(mem_stall_MEM),
        .pc4_MEM(pc4_MEM), .ALUres_MEM(ALUres_MEM), .MemRd_MEM(MemRd_MEM),
        .MemtoReg_MEM(MemtoReg_MEM), .Tnew_MEM(Tnew_MEM),
        .A3_MEM(A3_MEM), .RegWrite_MEM(RegWrite_MEM), .ExtImm_MEM(ExtImm_MEM),
        
        .pc4_WB(pc4_WB), .ALUres_WB(ALUres_WB), .MemRd_WB(MemRd_WB),
        .MemtoReg_WB(MemtoReg_WB), .Tnew_WB(Tnew_WB),
        .A3_WB(A3_WB), .RegWrite_WB(RegWrite_WB), .ExtImm_WB(ExtImm_WB)
    );

    decode decode(
        .Instr_ID(Instr_ID),
        .addu(addu), .subu(subu), .ori(ori), .lw(lw), .sw(sw), 
        .beq(beq), .lui(lui), .addi(addi), .addiu(addiu), 
        .slt(slt), .j(j), .jal(jal), .jr(jr),
        .A1(A1_ID), .A2(A2_ID), .A3(A3_ID)
    );

    AT AT(
        .addu(addu), .subu(subu), .ori(ori), .lw(lw), .sw(sw), 
        .beq(beq), .lui(lui), .addi(addi), .addiu(addiu), 
        .slt(slt), .j(j), .jal(jal), .jr(jr),
        .Tuse_rs(Tuse_rs), .Tuse_rt(Tuse_rt), .Tnew(Tnew_ID),
        .cal_ID(cal_ID), .load_ID(load_ID)
    );

    MCU MCU(
        .addu(addu), .subu(subu), .ori(ori), .lw(lw), .sw(sw), 
        .beq(beq), .lui(lui), .addi(addi), .addiu(addiu), 
        .slt(slt), .j(j), .jal(jal), .jr(jr),
        .PcSrc(PcSrc), .RegWrite(RegWrite_ID),
        .MemtoReg(MemtoReg_ID), // 0:运算结果 1:读存储器 2:PC+8 
        .MemWrite(MemWrite_ID), .ALUsrc(ALUsrc_ID), 
        .ALUctr(ALUctr_ID), .ExtOp(ExtOp)
    );

    HCU HCU(
        .mem_stall_MEM(mem_stall_MEM),
        .Tuse_rs(Tuse_rs), .Tuse_rt(Tuse_rt), 
        .cal_EX(cal_EX), .load_EX(load_EX), .load_MEM(load_MEM),
        .A3_EX(A3_EX), .A3_MEM(A3_MEM),
        .A1_ID(A1_ID), .A2_ID(A2_ID),
        .stall(stall)
    );

    FCU FCU(
        .A1_ID(A1_ID), .A1_EX(A1_EX),
        .A2_ID(A2_ID), .A2_EX(A2_EX), .A2_MEM(A2_MEM),
        .A3_ID(A3_ID), .A3_EX(A3_EX), .A3_MEM(A3_MEM), .A3_WB(A3_WB),
        .Tnew_EX(Tnew_EX), .Tnew_MEM(Tnew_MEM), .Tnew_WB(Tnew_WB),
        .MemWd_Fwd_ctr(MemWd_Fwd_ctr),
        .ALUa_Fwd_ctr(ALUa_Fwd_ctr), .ALUb_Fwd_ctr(ALUb_Fwd_ctr),
        .Rd1_Fwd_ctr(Rd1_Fwd_ctr), .Rd2_Fwd_ctr(Rd2_Fwd_ctr)
    );

endmodule