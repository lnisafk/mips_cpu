module IDEX(
	input clk, rst, stall, mem_stall,
	input [31:0] Rd1_ID, Rd2_ID, ExtImm_ID,
	input [31:0] pc4_ID, Instr_ID,
    input [4:0] A3_ID, A2_ID, A1_ID,
	input [1:0] Tnew_ID, MemtoReg_ID,
	input cal_ID, load_ID,
	input ALUsrc_ID, RegWrite_ID, MemWrite_ID,
	input [3:0] ALUctr_ID,
    output reg [31:0] Rd1_EX, Rd2_EX, ExtImm_EX,
	output reg [31:0] pc4_EX, Instr_EX,
	output reg [4:0] A1_EX, A2_EX, A3_EX,
	output reg cal_EX, load_EX,
    output reg RegWrite_EX, MemWrite_EX, ALUsrc_EX,
    output reg [1:0] Tnew_EX, MemtoReg_EX,
    output reg [3:0] ALUctr_EX
    );
	always@(posedge clk) begin
		if(rst) begin
			Rd1_EX <= 0;
			Rd2_EX <= 0;
			ExtImm_EX <= 0;
			pc4_EX <= 0;
			ALUsrc_EX <= 0;
			MemtoReg_EX <= 0;
			RegWrite_EX <= 0;
			MemWrite_EX <= 0;			
            ALUctr_EX <= 0;
			A1_EX <= 0;
			A2_EX <= 0;
			A3_EX <= 0;
			Tnew_EX <= 0;
			cal_EX <= 0;
			load_EX <= 0;
			Instr_EX <= 0;
		end else if (mem_stall) begin
			// do nothing
		end else if (stall) begin
			Rd1_EX <= 0;
			Rd2_EX <= 0;
			ExtImm_EX <= 0;
			pc4_EX <= 0;
			ALUsrc_EX <= 0;
			MemtoReg_EX <= 0;
			RegWrite_EX <= 0;
			MemWrite_EX <= 0;			
            ALUctr_EX <= 0;
			A1_EX <= 0;
			A2_EX <= 0;
			A3_EX <= 0;
			Tnew_EX <= 0;
			cal_EX <= 0;
			load_EX <= 0;
			Instr_EX <= 0;
		end else begin
			Rd1_EX <= Rd1_ID;
			Rd2_EX <= Rd2_ID;
			ExtImm_EX <= ExtImm_ID;
			pc4_EX <= pc4_ID;
			ALUsrc_EX <= ALUsrc_ID;
			MemtoReg_EX <= MemtoReg_ID;
			RegWrite_EX <= RegWrite_ID;
			MemWrite_EX <= MemWrite_ID;			
            ALUctr_EX <= ALUctr_ID;
			A1_EX <= A1_ID;
			A2_EX <= A2_ID;
			A3_EX <= A3_ID;
			Tnew_EX <= Tnew_ID;
			cal_EX <= cal_ID;
			load_EX <= load_ID;
			Instr_EX <= Instr_ID;
		end
	end
endmodule
