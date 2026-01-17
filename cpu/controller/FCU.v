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
		if (A1_ID == 0) 			Rd1_Fwd_ctr = 0;
		else if (A1_ID == A3_EX)
			if (Tnew_EX == 0) 		Rd1_Fwd_ctr = 1;	// 如果beq上一条指令是lui，并且写后读，那么转发ExtImm_EX
        	else 					Rd1_Fwd_ctr = 0;
		else if (A1_ID == A3_MEM) 
			if (Tnew_MEM == 0) 		Rd1_Fwd_ctr = 2;	// 上上条是lui，转发ExtImm_MEM。如果上一条是add，并且写后读，那只能stall
        	else if (Tnew_MEM == 1) Rd1_Fwd_ctr = 3;	// 上上上条是lui，转发ExtImm_WB
        	else 					Rd1_Fwd_ctr = 0;
		else if (A1_ID == A3_WB)
			if (Tnew_WB == 0) 		Rd1_Fwd_ctr = 4;
        	else if (Tnew_WB == 1) 	Rd1_Fwd_ctr = 5;
        	else if (Tnew_WB == 2) 	Rd1_Fwd_ctr = 6;
        	else 					Rd1_Fwd_ctr = 0;
		else 						Rd1_Fwd_ctr = 0;
		// Rd2
		if (A2_ID == 0) 			Rd2_Fwd_ctr = 0;
		else if (A2_ID == A3_EX)
        	if (Tnew_EX == 0) 		Rd2_Fwd_ctr = 1;
        	else 					Rd2_Fwd_ctr = 0;
    	else if (A2_ID == A3_MEM)
        	if (Tnew_MEM == 0) 		Rd2_Fwd_ctr = 2;
        	else if (Tnew_MEM == 1) Rd2_Fwd_ctr = 3;
        	else 					Rd2_Fwd_ctr = 0;
    	else if (A2_ID == A3_WB)
        	if (Tnew_WB == 0) 		Rd2_Fwd_ctr = 4;
        	else if (Tnew_WB == 1) 	Rd2_Fwd_ctr = 5;
        	else if (Tnew_WB == 2) 	Rd2_Fwd_ctr = 6;
        	else 					Rd2_Fwd_ctr = 0;
    	else 						Rd2_Fwd_ctr = 0;
		// ALUa
		if (A1_EX == 0) 			ALUa_Fwd_ctr = 0;	// 没读
		else if (A1_EX == A3_MEM) 						// 上条指令要写，写的数据产生了吗？
        	if (Tnew_MEM == 0) 		ALUa_Fwd_ctr = 1; 	// 数据已产生
        	else if (Tnew_MEM == 1) ALUa_Fwd_ctr = 2; 	// 上条是lui等，流到了ExtImm_MEM
        	else 					ALUa_Fwd_ctr = 0;
    	else if (A1_EX == A3_WB) 						// 上上条指令要写
        	if (Tnew_WB == 0) 		ALUa_Fwd_ctr = 3;	// 上上条写，数据已就绪
        	else if (Tnew_WB == 1) 	ALUa_Fwd_ctr = 4;	// Tnew是1或2都行
        	else if (Tnew_WB == 2) 	ALUa_Fwd_ctr = 5;	// 上上条是lui，流到了ExtImm_WB
        	else 					ALUa_Fwd_ctr = 0;
    	else 						ALUa_Fwd_ctr = 0;
		// ALUb
		if (A2_EX == 0) 			ALUb_Fwd_ctr = 0;
		else if (A2_EX == A3_MEM)
        	if (Tnew_MEM == 0) 		ALUb_Fwd_ctr = 1;
        	else if (Tnew_MEM == 1) ALUb_Fwd_ctr = 2;
        	else 					ALUb_Fwd_ctr = 0;
    	else if (A2_EX == A3_WB)
        	if (Tnew_WB == 0) 		ALUb_Fwd_ctr = 3;
        	else if (Tnew_WB == 1) 	ALUb_Fwd_ctr = 4;
        	else if (Tnew_WB == 2) 	ALUb_Fwd_ctr = 5;
        	else 					ALUb_Fwd_ctr = 0;
    	else 						ALUb_Fwd_ctr = 0;
		// MemWd
		if (A2_MEM == 0) 			MemWd_Fwd_ctr = 0;
		else if (A2_MEM == A3_WB)						// 上一条指令要写A2，但还没写进去
			if (Tnew_WB == 0) 		MemWd_Fwd_ctr = 1;	// 上一条指令1周期出结果，MEM阶段已经过两周期了，所以已经有数据
        	else if (Tnew_WB == 1) 	MemWd_Fwd_ctr = 2;
        	else if (Tnew_WB == 2) 	MemWd_Fwd_ctr = 3;
        	else 					MemWd_Fwd_ctr = 0;
		else 						MemWd_Fwd_ctr = 0;
    end 
endmodule