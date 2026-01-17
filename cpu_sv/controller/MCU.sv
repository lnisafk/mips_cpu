`timescale 1ns / 1ps
import mips_pkg::*;

module MCU(
    input  logic addu, subu, ori, lw, sw, beq, lui, addi, addiu, slt, j, jal, jr,
    output logic [1:0]    PcSrc,    // 0:pc+4, 1:beq, 2:j/jal, 3:jr
    output logic          RegWrite,
    output logic [1:0]    MemtoReg, // 0:ALU, 1:Mem, 2:PC+8, 3:ExtImm
    output logic          MemWrite,
    output logic          ALUsrc,
    output alu_op_t       ALUctr,   // 使用枚举
    output logic [1:0]    ExtOp     // 0:Zero, 1:LUI, 2:Sign
);

    always_comb begin
        // 1. PcSrc
        if (beq)           PcSrc = 2'd1;
        else if (j | jal)  PcSrc = 2'd2;
        else if (jr)       PcSrc = 2'd3;
        else               PcSrc = 2'd0;
        // 2. RegWrite
        RegWrite = (addu|subu|ori|lw|lui|addi|addiu|slt|jal);
        // 3. MemtoReg
        if (lw)       MemtoReg = 2'd1;
        else if (jal) MemtoReg = 2'd2;
        else if (lui) MemtoReg = 2'd3;
        else          MemtoReg = 2'd0;
        // 4. MemWrite
        MemWrite = sw;
        // 5. ALUsrc
        ALUsrc = (ori|lw|sw|addi|addiu|lui);
        // 6. ExtOp
        if (ori)      ExtOp = 2'd0;
        else if (lui) ExtOp = 2'd1;
        else          ExtOp = 2'd2; // 符号扩展
        // 7. ALUctr
        if (ori)                ALUctr = ALU_OR;
        else if (lw|sw|addi)    ALUctr = ALU_ADD;
        else if (slt)           ALUctr = ALU_SLT;
        else if (addu|addiu)    ALUctr = ALU_ADDU;
        else if (subu|beq)      ALUctr = ALU_SUBU;
        else                    ALUctr = ALU_AND;  // 防锁存
    end

endmodule