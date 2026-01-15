`include "./datapath/ALU.v"
module Stage_EX(
	input [31:0] Instr_EX,
	input [2:0] ALUa_Fwd_ctr, ALUb_Fwd_ctr,
	input [31:0] ALUres_MEM, ALUres_WB, MemRd_WB, ExtImm_MEM, ExtImm_WB,
	input [31:0] Rd1, Rd2, ExtImm,
	input [3:0] ALUctr,
	input ALUsrc,
	output [31:0] ALUres, ALUb_Fwd
    );
    wire [31:0] ALUa_Fwd;
    assign ALUa_Fwd = (ALUa_Fwd_ctr == 0)?Rd1:
                      (ALUa_Fwd_ctr == 1)?ExtImm_MEM:
                      (ALUa_Fwd_ctr == 2)?ALUres_MEM:
                      (ALUa_Fwd_ctr == 3)?ExtImm_WB:
                      (ALUa_Fwd_ctr == 4)?ALUres_WB:
                      (ALUa_Fwd_ctr == 5)?MemRd_WB:0;
    assign ALUb_Fwd = (ALUb_Fwd_ctr == 0)?Rd2:
                      (ALUb_Fwd_ctr == 1)?ExtImm_MEM:
                      (ALUb_Fwd_ctr == 2)?ALUres_MEM:
                      (ALUb_Fwd_ctr == 3)?ExtImm_WB:
                      (ALUb_Fwd_ctr == 4)?ALUres_WB:
                      (ALUb_Fwd_ctr == 5)?MemRd_WB:0;
    wire [31:0]ALUb;
    assign ALUb = (ALUsrc == 0)?ALUb_Fwd:ExtImm;
    ALU ALU(
    	.A(ALUa_Fwd),
    	.B(ALUb),
    	.ALUctr(ALUctr),
    	.ALUres(ALUres)
    );
endmodule