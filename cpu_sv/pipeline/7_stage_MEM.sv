module Stage_MEM(
    input  logic        clk, rst,
    input  logic [31:0] MemWd, ALUres_MEM, ALUres_WB, MemRd_WB, ExtImm_WB,
    input  logic        MemWrite, 
    input  logic [1:0]  MemtoReg,
    input  logic [1:0]  MemWd_Fwd_ctr,
    output logic [31:0] MemRd,
    output logic        mem_stall
);

    logic [31:0] MemWd_Fwd;
    logic [31:0] mem_rdata;
    logic        cache_ready;
    logic [31:0] mem_addr;

    // Mem write data
    always_comb begin
        case (MemWd_Fwd_ctr)
            2'd0: MemWd_Fwd = MemWd;
            2'd1: MemWd_Fwd = ExtImm_WB;
            2'd2: MemWd_Fwd = ALUres_WB;
            2'd3: MemWd_Fwd = MemRd_WB;
            default: MemWd_Fwd = '0;
        endcase
    end

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

endmodule