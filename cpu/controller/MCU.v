module MCU(
    input addu, subu, ori, lw, sw, beq, lui,addi, addiu, slt, j, jal, jr,
    output reg [1:0] PcSrc,             // 0:pc+4 1:beq 2:j 3:jr
    output reg RegWrite,
    output reg [1:0] RegDst,            // 0:写rt 1:写rd 2:jal写r31 
    output reg [1:0] MemtoReg,          // 0:运算结果 1:读存储器 2:扩展立即数 3:PC+8
    output reg MemWrite,
    output reg ALUsrc, 
    output reg [3:0] ALUctr,
    output reg [1:0] ExtOp
);
always @(*) begin
        // PcSrc
        if (beq) PcSrc = 1;
        else if (j | jal) PcSrc = 2;
        else if (jr) PcSrc = 3;
        else PcSrc = 0;
        // RegWrite
        if (addu|subu|ori|lw|lui|addi|addiu|slt|jal) RegWrite = 1;
        else RegWrite = 0;
        // MemtoReg
        if (lw) MemtoReg = 1;
        else if (jal) MemtoReg = 2;
        else if (lui) MemtoReg = 3;
        else MemtoReg = 0;
        // MemWrite
        if (sw) MemWrite = 1;
        else MemWrite = 0;
        // ALUsrc
        if (ori|lw|sw|addi|addiu|lui) ALUsrc = 1;
        else ALUsrc = 0;
        // ExtOp
        if (ori) ExtOp = 0;
        else if (lui) ExtOp = 1;
        else ExtOp = 2; // 符号扩展
        // ALUctr
        if (ori) ALUctr = 4'b0001;
        else if (lw|sw|addi) ALUctr = 4'b0010;
        else if (slt) ALUctr = 4'b0111;
        else if (addu|addiu) ALUctr = 4'b1000;
        else if (subu|beq) ALUctr = 4'b1010;
        else ALUctr = 0;
    end
endmodule