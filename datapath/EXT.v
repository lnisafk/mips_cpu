`timescale 1ns / 1ps
module EXT(
    input [15:0] Imm,
    input [1:0] ExtOp,
    output reg [31:0] ExtImm
);
    always@* begin
        if (ExtOp == 0) 
            ExtImm <= {16'h0,Imm};
        else if (ExtOp == 1)
            ExtImm <= {Imm,16'h0};
        else
            ExtImm <= {{16{Imm[15]}},Imm};
    end

endmodule