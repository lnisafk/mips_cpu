`timescale 1ns / 1ps
`ifndef _GPR
`define _GPR 
module GPR(
    input  clk, rst,
    input  RegWrite,
    input  [4:0] A1, A2, A3,
    input  [31:0] Wd,
    output [31:0] Rd1, Rd2
);
    reg [31:0] registers[31:0];    // 寄存器堆

    integer i;
    initial
        for(i = 0; i < 32; i = i + 1)
            registers[i] = 32'h00000000;

    assign Rd1 = (A1==A3 && RegWrite)? Wd : registers[A1];
    assign Rd2 = (A2==A3 && RegWrite)? Wd : registers[A2];
    // 内部转发，让WB写入的数据能及时输出，规避数据冒险
    always@(posedge clk) begin
        if (rst == 1)
            for(i = 0; i < 32; i = i + 1)
                registers[i] <= 0;
        if (RegWrite == 1)
            begin
                registers[A3] <= Wd;
                $display("GPR -- Regs: %d <- %h", A3, Wd);
            end
    end
  
endmodule
`endif