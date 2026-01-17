import mips_pkg::*;

module Stage_EX(
    input  logic [31:0] Instr_EX, // 其实EX不需要指令本身
    input  logic [2:0]  ALUa_Fwd_ctr, ALUb_Fwd_ctr,
    input  logic [31:0] ALUres_MEM, ALUres_WB, MemRd_WB, ExtImm_MEM, ExtImm_WB,
    input  logic [31:0] Rd1, Rd2, ExtImm,
    input  alu_op_t     ALUctr,
    input  logic        ALUsrc,
    output logic [31:0] ALUres,
    output logic [31:0] ALUb_Fwd // 后续阶段作为MemWd
);

    logic [31:0] ALUa_Fwd;
    logic [31:0] ALUb;

    // ALUa
    always_comb begin
        case (ALUa_Fwd_ctr)
            3'd0: ALUa_Fwd = Rd1;
            3'd1: ALUa_Fwd = ExtImm_MEM;
            3'd2: ALUa_Fwd = ALUres_MEM;
            3'd3: ALUa_Fwd = ExtImm_WB;
            3'd4: ALUa_Fwd = ALUres_WB;
            3'd5: ALUa_Fwd = MemRd_WB;
            default: ALUa_Fwd = '0;
        endcase
    end

    // ALUb
    always_comb begin
        case (ALUb_Fwd_ctr)
            3'd0: ALUb_Fwd = Rd2;
            3'd1: ALUb_Fwd = ExtImm_MEM;
            3'd2: ALUb_Fwd = ALUres_MEM;
            3'd3: ALUb_Fwd = ExtImm_WB;
            3'd4: ALUb_Fwd = ALUres_WB;
            3'd5: ALUb_Fwd = MemRd_WB;
            default: ALUb_Fwd = '0;
        endcase
    end

    // ALU Source
    assign ALUb = (ALUsrc == 0) ? ALUb_Fwd : ExtImm;

    ALU u_ALU(
        .A(ALUa_Fwd),
        .B(ALUb),
        .ALUctr(ALUctr),
        .ALUres(ALUres)
    );

endmodule