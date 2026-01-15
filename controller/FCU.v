module FCU (
    input [4:0] A1_ID, A1_EX,
    input [4:0] A2_ID, A2_EX, A2_MEM,
    input [4:0] A3_ID, A3_EX, A3_MEM, A3_WB,
    input [1:0] Tnew_EX, Tnew_MEM, Tnew_WB,
    output reg [1:0] MemWd_Fwd_ctr,
    output reg [2:0] ALUa_Fwd_ctr, ALUb_Fwd_ctr,
    output reg [2:0] Rd1_Fwd_ctr, Rd2_Fwd_ctr
);
    always @(*)begin
		// Rd1
		if (A1_ID == 0) Rd1_Fwd_ctr <= 0;
		// 如果beq上一条指令是lui，并且写后读，那么转发ExtImm_EX
		else if (A1_ID == A3_EX)
			Rd1_Fwd_ctr <= (Tnew_EX==0) ? 1:0;
		// 如果beq上一条指令是add，并且写后读，那只能stall
		else if (A1_ID == A3_MEM) 
			Rd1_Fwd_ctr <= (Tnew_MEM==0) ? 2:
						   (Tnew_MEM==1) ? 3:0;	// 上上条是lui，转发ExtImm_MEM
		else if (A1_ID == A3_WB) 
			Rd1_Fwd_ctr <= (Tnew_WB==0) ? 4:
						   (Tnew_WB==1) ? 5:
						   (Tnew_WB==2) ? 6:0;		// 上上上条是lui，转发ExtImm_WB
		else Rd1_Fwd_ctr <= 0; 
		// Rd2
		if (A2_ID == 0) Rd2_Fwd_ctr <= 0;
		else if (A2_ID == A3_EX)
			Rd2_Fwd_ctr <= (Tnew_EX==0) ? 1:0;
		else if (A2_ID == A3_MEM) 
			Rd2_Fwd_ctr <= (Tnew_MEM==0) ? 2:
						   (Tnew_MEM==1) ? 3:0;
		else if (A2_ID == A3_WB) 
			Rd2_Fwd_ctr <= (Tnew_WB==0) ? 4:
						   (Tnew_WB==1) ? 5:
						   (Tnew_WB==2) ? 6:0;
		else Rd2_Fwd_ctr <= 0;   
		// ALUa
		if (A1_EX == 0) ALUa_Fwd_ctr <= 0;			// 没读
		else if (A1_EX == A3_MEM) 					// 上条指令要写，写的数据产生了吗？
			ALUa_Fwd_ctr <= (Tnew_MEM==0) ? 1:	 	// 上条指令Tnew==1，现在过了1周期，所以数据已经产生了
							(Tnew_MEM==1) ? 2:0;	// 上条指令是lui，现在是本条指令的EX，所以上条流水到ExtImm_MEM
		else if (A1_EX == A3_WB) 				
			ALUa_Fwd_ctr <= (Tnew_WB==0) ? 3:		// 上上条指令要写，数据？
							(Tnew_WB==1) ? 4:		// Tnew是1或2都行
							(Tnew_WB==2) ? 5:0;		// 上上条指令是lui，现在是本条指令的EX，所以上上条流水到ExtImm_WB
		else ALUa_Fwd_ctr <= 0;
		// ALUb
		if (A2_EX == 0) ALUb_Fwd_ctr <= 0;
		else if (A2_EX == A3_MEM) 
			ALUb_Fwd_ctr <= (Tnew_MEM==0) ? 1:
							(Tnew_MEM==1) ? 2:0;
		else if (A2_EX == A3_WB) 
			ALUb_Fwd_ctr <= (Tnew_WB==0) ? 3:
							(Tnew_WB==1) ? 4:
							(Tnew_WB==2) ? 5:0;
		else ALUb_Fwd_ctr <= 0;                          
		// MemWd
		if (A2_MEM == 0) MemWd_Fwd_ctr <= 0;
		else if (A2_MEM == A3_WB) 					// 上一条指令要写A2，但还没写进去
			MemWd_Fwd_ctr <= (Tnew_WB==0) ? 1:		// 上一条指令1周期出结果，MEM阶段已经过两周期了，所以已经有数据
							 (Tnew_WB==1) ? 2:
							 (Tnew_WB==2) ? 3:0;
    end 
endmodule