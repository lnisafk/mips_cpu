module IFID(
    input [31:0] Instr_IF,
    input [31:0] pc4_IF,
    input clk, rst, stall, //flush,
	output reg [31:0] pc4_ID,
    output reg [31:0] Instr_ID
    );
	always@(posedge clk)begin
		if (rst) begin
			Instr_ID <= 0;
			pc4_ID <= 0;
		end else if (!stall) begin
			Instr_ID <= Instr_IF;
			pc4_ID <= pc4_IF;
		end	
    end
endmodule