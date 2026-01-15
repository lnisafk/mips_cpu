module EXMEM (
	input clk, rst, stall,
	input [31:0] MemWd_EX, ALUres_EX, pc4_EX,
	input [1:0] MemtoReg_EX, Tnew_EX,
	input load_EX,
	input RegWrite_EX, MemWrite_EX,
	input [4:0] A2_EX, A3_EX,
	input [31:0] ExtImm_EX,
    output reg[31:0] MemWd_MEM, ALUres_MEM, pc4_MEM,
	output reg [1:0] MemtoReg_MEM, Tnew_MEM,
	output reg load_MEM,
	output reg RegWrite_MEM, MemWrite_MEM,
	output reg [4:0] A2_MEM, A3_MEM,
	output reg [31:0] ExtImm_MEM
);
	always@(posedge clk) begin		
        if (rst) begin
			ALUres_MEM <= 0;
			MemWd_MEM <= 0;
			pc4_MEM <= 0;
			MemtoReg_MEM <= 0;
			RegWrite_MEM <= 0;
			MemWrite_MEM <= 0;
			A2_MEM <= 0;
			A3_MEM <= 0;
			Tnew_MEM <= 0;
			load_MEM <= 0;
			ExtImm_MEM <= 0;
		end else if (!stall) begin
			ALUres_MEM <= ALUres_EX;
			MemWd_MEM <= MemWd_EX;
			pc4_MEM <= pc4_EX;
			MemtoReg_MEM <= MemtoReg_EX;
			RegWrite_MEM <= RegWrite_EX;
			MemWrite_MEM <= MemWrite_EX;
			A2_MEM <= A2_EX;
			A3_MEM <= A3_EX;
			Tnew_MEM <= Tnew_EX;
			load_MEM <= load_EX;
			ExtImm_MEM <= ExtImm_EX;
		end
	end
endmodule 
