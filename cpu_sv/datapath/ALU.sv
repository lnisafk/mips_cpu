`timescale 1ns / 1ps
import mips_pkg::*;
module ALU(
    input  logic [31:0] A, B,
    input  alu_op_t     ALUctr, // 枚举类型
    output logic [31:0] ALUres
);
    always_comb begin
        case(ALUctr) // unique case 指示综合器这是完备且互斥的
            ALU_AND:  ALUres = A & B;
            ALU_OR :  ALUres = A | B;
            ALU_ADD:  ALUres = A + B;   // 不处理异常，行为与addu一致
            ALU_SUB:  ALUres = A - B;
            ALU_SLT:  ALUres = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            ALU_NOR:  ALUres = ~(A | B);
            ALU_ADDU: ALUres = A + B;
            ALU_SUBU: ALUres = A - B;
            ALU_SLTU: ALUres = (A < B) ? 32'd1 : 32'd0;
            default:  ALUres = '0;
        endcase
    end
endmodule