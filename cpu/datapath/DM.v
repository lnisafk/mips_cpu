`timescale 1ns / 1ps
module DM(
    input clk, rst,
    input MemWrite,
    input [31:0] Wd,  raddr, waddr,
    output reg[31:0] Rd
);
    reg [31:0] RAM [1023:0];
    integer i;
    initial begin
		for (i = 0; i < 32; i = i + 1)
			RAM[i] = 0;
	end
    always@* begin
        Rd <= RAM[raddr[11:2]];
    end
    always@(posedge clk) begin
        if (rst == 1)
            for (i = 0; i < 1023; i = i + 1)
                RAM[i] <= 0;
        else if (MemWrite == 1) begin
                RAM[waddr[11:2]] <= Wd;
                $display("DM  -- %h <- %h", waddr[11:2], Wd);	
        end
    end
endmodule

