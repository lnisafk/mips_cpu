module MCU(
    input addu, subu, ori, lw, sw, beq, lui,addi, addiu, slt, j, jal, jr,
    output [1:0] PcSrc,             // 0:pc+4 1:beq 2:j 3:jr
    output RegWrite,
    output [1:0] RegDst,            // 0:写rt 1:写rd 2:jal写r31 
    output [1:0] MemtoReg,          // 0:运算结果 1:读存储器 2:扩展立即数 3:PC+8
    output MemWrite,
    output ALUsrc, 
    output [3:0] ALUctr,
    output [1:0] ExtOp
);
    assign PcSrc    = (beq)?1:(j|jal)?2:(jr)?3:0;
    assign RegWrite = (addu|subu|ori|lw|lui|addi|addiu|slt|jal)?1:0;
    assign MemtoReg = (addu|subu|addi|addiu|ori)?0:(lw)?1:(jal)?2:(lui)?3:0;
    assign MemWrite = (sw)?1:0;
    assign ALUsrc   = (ori|lw|sw|addi|addiu|lui)?1:0;
    assign ALUctr   = (ori)          ?4'b0001:
                      (lw|sw|addi)  ?4'b0010:
                      (slt)             ?4'b0111:
                      (addu|addiu)      ?4'b1000:
                      (subu|beq)        ?4'b1010:0;
    assign ExtOp    = (ori)?0:(lui)?1:(0)?2:0;
endmodule