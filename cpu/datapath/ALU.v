`timescale 1ns / 1ps
module ALU(
    input [31:0] A, B,
    input [3:0]  ALUctr,
    output reg [31:0] ALUres
);
    localparam ALU_AND = 4'b0000,
               ALU_OR  = 4'b0001,
               ALU_ADD = 4'b0010,   // lw, sw, addi
               ALU_SUB = 4'b0110,
               ALU_SLT = 4'b0111,
               ALU_NOR = 4'b1100,
               ALU_ADDU= 4'b1000,
               ALU_SUBU= 4'b1010,   // subu, beq
               ALU_SLTU= 4'b1011;
    wire [31:0] temp;
    assign temp = A + B;
    always@* begin
        case(ALUctr)
            ALU_AND: ALUres <= A & B;
            ALU_OR : ALUres <= A | B;
            ALU_ADD: ALUres <= A + B;   // 不处理异常，行为与addu一致
            ALU_SUB: ALUres <= A - B;
            ALU_SLT: ALUres <= ($signed(A) < $signed(B)) ? 1:0;
            ALU_NOR: ALUres <= !(A | B);
            ALU_ADDU: ALUres <= A + B;
            ALU_SUBU: ALUres <= A - B;
            ALU_SLTU: ALUres <= (A<B)?1:0;
            default: ALUres <= 0;
        endcase
    end
endmodule