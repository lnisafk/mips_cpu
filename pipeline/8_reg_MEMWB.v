module MEMWB (
	input clk, rst, stall,
	input [31:0] pc4_MEM, ALUres_MEM, MemRd_MEM,
	input [1:0] MemtoReg_MEM, Tnew_MEM,
	input [4:0] A3_MEM,
	input RegWrite_MEM,
	inout [31:0] ExtImm_MEM,
	output reg [31:0] pc4_WB, ALUres_WB, MemRd_WB,
    output reg [1:0] MemtoReg_WB, Tnew_WB,
	output reg [4:0] A3_WB,
    output reg RegWrite_WB,
	output reg [31:0] ExtImm_WB
);
	always@(posedge clk) begin
		if(rst) begin
            pc4_WB <= 0;
			ALUres_WB <= 0;
			MemRd_WB <= 0;
			MemtoReg_WB <= 0;
			RegWrite_WB <= 0;
			A3_WB <= 0;
			Tnew_WB <= 0;
			ExtImm_WB <= 0;
		end else if (!stall) begin
			pc4_WB <= pc4_MEM;
			ALUres_WB <= ALUres_MEM;
			MemRd_WB <= MemRd_MEM;
			MemtoReg_WB <= MemtoReg_MEM;
			RegWrite_WB <= RegWrite_MEM;
			A3_WB <= A3_MEM;
			Tnew_WB <= Tnew_MEM;
			ExtImm_WB <= ExtImm_MEM;
		end
	end
endmodule
