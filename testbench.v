`timescale 1ns / 1ps
`include "./0_mips.v"
module tb;
  reg clk, rst;
  
  initial begin
    clk = 0;
    rst = 1;
    #3 rst = 0;
    #70 $finish;
  end
  
  mips mips(
    .clk(clk), .rst(rst)
  );

  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    $dumpfile("mips.vcd");
		$dumpvars;
	end
endmodule