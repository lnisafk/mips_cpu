module Stage_MEM(
    input clk, rst,
	input [31:0] MemWd, ALUres_MEM, ALUres_WB, MemRd_WB, ExtImm_WB,
	input MemWrite, 
    input [1:0] MemtoReg,
	input [1:0] MemWd_Fwd_ctr,
	output [31:0] MemRd,
	output mem_stall              // 缓存未命中时暂停流水线
);
    reg [31:0] MemWd_Fwd;
    always @(*) begin
        case (MemWd_Fwd_ctr)
            2'd0: MemWd_Fwd = MemWd;
            2'd1: MemWd_Fwd = ExtImm_WB;
            2'd2: MemWd_Fwd = ALUres_WB;
            2'd3: MemWd_Fwd = MemRd_WB;
            default: MemWd_Fwd = 32'd0;
        endcase
    end
	// 考虑jal写r31，但是一般不读r31的内容
	wire [31:0] mem_rdata;
    wire        cache_ready;
    wire [31:0] mem_addr;
    
	DCache u_DCache(
        .clk(clk), .rst(rst),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .addr(ALUres_MEM),
        .wdata(MemWd_Fwd),
        .rdata(MemRd),
		// 主存接口
        .ready(cache_ready),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata)
    );
	DM u_DM(
        .clk(clk), .rst(rst),
        .MemWrite(MemWrite),
        .waddr(ALUres_MEM),
        .raddr(mem_addr),
        .Wd(MemWd_Fwd),
        .Rd(mem_rdata)
    );
	assign mem_stall = ~cache_ready;
	/*
    DM DM(
    	.address(ALUres_MEM),
    	.Wd(MemWd_Fwd),
    	.MemWrite(MemWrite),
    	.clk(clk), .rst(rst),
    	.Rd(MemRd)
    );
	*/
endmodule