module Stage_EX(
	input [31:0] Instr_EX,
	input [2:0] ALUa_Fwd_ctr, ALUb_Fwd_ctr,
	input [31:0] ALUres_MEM, ALUres_WB, MemRd_WB, ExtImm_MEM, ExtImm_WB,
	input [31:0] Rd1, Rd2, ExtImm,
	input [3:0] ALUctr,
	input ALUsrc,
	output [31:0] ALUres,
    output reg [31:0] ALUb_Fwd
);
    reg [31:0] ALUa_Fwd;
    always @(*) begin
        case (ALUa_Fwd_ctr)
            3'd0: ALUa_Fwd = Rd1;
            3'd1: ALUa_Fwd = ExtImm_MEM;
            3'd2: ALUa_Fwd = ALUres_MEM;
            3'd3: ALUa_Fwd = ExtImm_WB;
            3'd4: ALUa_Fwd = ALUres_WB;
            3'd5: ALUa_Fwd = MemRd_WB;
            default: ALUa_Fwd = 32'd0;
        endcase
    end
    always @(*) begin
        case (ALUb_Fwd_ctr)
            3'd0: ALUb_Fwd = Rd2;
            3'd1: ALUb_Fwd = ExtImm_MEM;
            3'd2: ALUb_Fwd = ALUres_MEM;
            3'd3: ALUb_Fwd = ExtImm_WB;
            3'd4: ALUb_Fwd = ALUres_WB;
            3'd5: ALUb_Fwd = MemRd_WB;
            default: ALUb_Fwd = 32'd0;
        endcase
    end
    wire [31:0]ALUb;
    assign ALUb = (ALUsrc == 0)?ALUb_Fwd:ExtImm;
    ALU ALU(
    	.A(ALUa_Fwd),
    	.B(ALUb),
    	.ALUctr(ALUctr),
    	.ALUres(ALUres)
    );
endmodule