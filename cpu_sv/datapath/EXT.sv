`timescale 1ns / 1ps
module EXT(
    input  logic [15:0] Imm,
    input  logic [1:0]  ExtOp,
    output logic [31:0] ExtImm
);

    always @(*) begin
        case (ExtOp)
            2'd0: ExtImm = {16'h0000, Imm};          // 零扩展
            2'd1: ExtImm = {Imm, 16'h0000};          // lui
            2'd2: ExtImm = {{16{Imm[15]}}, Imm};     // 符号扩展
            default: ExtImm = '0;
        endcase
    end

endmodule