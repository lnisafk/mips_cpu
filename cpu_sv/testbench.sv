`timescale 1ns / 1ps

module tb;
    logic clk, rst;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    // Reset generation
    initial begin
        rst = 1;
        #3 rst = 0;
      #200 $finish;
    end
    
    mips mips(
        .clk(clk), .rst(rst)
    );
    
    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, tb);
    end
endmodule