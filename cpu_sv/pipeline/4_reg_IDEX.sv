import mips_pkg::*;

module IDEX(
    input  logic        clk, rst, stall, mem_stall,
    // Data
    input  logic [31:0] Rd1_ID, Rd2_ID, ExtImm_ID,
    input  logic [31:0] pc4_ID, Instr_ID,
    input  logic [4:0]  A3_ID, A2_ID, A1_ID,
    // Control
    input  logic [1:0]  Tnew_ID, MemtoReg_ID,
    input  logic        cal_ID, load_ID,
    input  logic        ALUsrc_ID, RegWrite_ID, MemWrite_ID,
    input  alu_op_t     ALUctr_ID,
    // Output
    output logic [31:0] Rd1_EX, Rd2_EX, ExtImm_EX,
    output logic [31:0] pc4_EX, Instr_EX,
    output logic [4:0]  A1_EX, A2_EX, A3_EX,
    output logic        cal_EX, load_EX,
    output logic        RegWrite_EX, MemWrite_EX, ALUsrc_EX,
    output logic [1:0]  Tnew_EX, MemtoReg_EX,
    output alu_op_t     ALUctr_EX
);

    always_ff @(posedge clk) begin
        if (rst || stall) begin 
            // stall插入nop，控制信号清零
            // mem_stall保持原值（冻结流水线）
            Rd1_EX      <= '0;
            Rd2_EX      <= '0;
            ExtImm_EX   <= '0;
            pc4_EX      <= '0;
            Instr_EX    <= '0;
            
            A1_EX       <= '0;
            A2_EX       <= '0;
            A3_EX       <= '0;
            
            Tnew_EX     <= '0;
            MemtoReg_EX <= '0;
            
            cal_EX      <= 0;
            load_EX     <= 0;
            ALUsrc_EX   <= 0;
            RegWrite_EX <= 0;
            MemWrite_EX <= 0;
            ALUctr_EX   <= ALU_AND; // default
            
        end else if (!mem_stall) begin
            // 正常流动
            Rd1_EX      <= Rd1_ID;
            Rd2_EX      <= Rd2_ID;
            ExtImm_EX   <= ExtImm_ID;
            pc4_EX      <= pc4_ID;
            Instr_EX    <= Instr_ID;
            
            A1_EX       <= A1_ID;
            A2_EX       <= A2_ID;
            A3_EX       <= A3_ID;
            
            Tnew_EX     <= Tnew_ID;
            MemtoReg_EX <= MemtoReg_ID;
            
            cal_EX      <= cal_ID;
            load_EX     <= load_ID;
            ALUsrc_EX   <= ALUsrc_ID;
            RegWrite_EX <= RegWrite_ID;
            MemWrite_EX <= MemWrite_ID;
            ALUctr_EX   <= ALUctr_ID;
        end
        // else: mem_stall -> hold
    end
endmodule