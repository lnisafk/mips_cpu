// 传入D级指令码，输出是什么指令
module decode(
    input [31:0] Instr_ID,
    output addu, subu, ori, lw, sw, beq, lui,addi, addiu, slt, j, jal, jr,
    output [4:0] A1, A2, A3
);
    wire R;
    wire [5:0] op = Instr_ID[31:26];
    wire [5:0] funct = Instr_ID[5:0];
    assign R     = (op == 6'b000000);
	assign addu  = R&(funct == 6'b100001);
	assign subu  = R&(funct == 6'b100011);
    assign jr    = R&(funct == 6'b001000);
    assign slt   = R&(funct == 6'b101010);
    assign addi  = (op == 6'b001000);
    assign addiu = (op == 6'b001001);
    assign j     = (op == 6'b000010);
    assign jal   = (op == 6'b000011);
	assign ori   = (op == 6'b001101);
    assign lw    = (op == 6'b100011);
	assign sw    = (op == 6'b101011);
	assign beq   = (op == 6'b000100);
	assign lui   = (op == 6'b001111);
    assign A1 = Instr_ID[25:21];
    assign A2 = Instr_ID[20:16];
    assign A3 = (addu|subu|slt)?Instr_ID[15:11]:
				(ori|lw|lui|addi|addiu)?Instr_ID[20:16]:
				(jal)?5'd31:0;
endmodule