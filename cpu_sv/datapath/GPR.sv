`timescale 1ns / 1ps

module GPR(
    input  logic        clk, rst,
    input  logic        RegWrite,
    input  logic [4:0]  A1, A2, A3,
    input  logic [31:0] Wd,
    output logic [31:0] Rd1, Rd2
);
    // 寄存器堆
    logic [31:0] registers[31:0];

    // 读逻辑：组合逻辑，包含内部转发（RAW）
    always_comb begin
        // 如果读地址是0，总是返回0
        // 如果读地址等于写地址且正在写，直接转发Wd
        // 否则读寄存器堆
        if (A1 == '0)       Rd1 = '0;
        else if (A1 == A3 && RegWrite)  Rd1 = Wd;
        else                Rd1 = registers[A1];
        if (A2 == '0)       Rd2 = '0;
        else if (A2 == A3 && RegWrite)  Rd2 = Wd;
        else                Rd2 = registers[A2];
    end

    // 写逻辑：时序逻辑
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 32; i++)
                registers[i] <= '0;
        end 
        else if (RegWrite && A3 != 0) begin // 禁止写$0
            registers[A3] <= Wd;
            $display("GPR -- Regs: %d <- %h", A3, Wd); 
        end
    end

endmodule