`timescale 1ns / 1ps
module ALU(
    input [31:0] A, B,
    input [3:0]  ALUctr,
    output reg [31:0] ALUres
);
    wire [31:0] temp;
    assign temp = A + B;
    always@* begin
        case(ALUctr)
        4'b0000: ALUres <= A & B;
        4'b0001: ALUres <= A | B;
        4'b0010: if (A[31]==0 || B[31]==0)
                    if (temp[31] == 0) ALUres <= A;
                    else ALUres <= temp;
                 else ALUres <= A;
        4'b0110: begin
            ALUres <= A - B;
        end 
        4'b0111: begin
            ALUres <= (A<B)?1:0;
        end 
        4'b1100: ALUres <= !(A | B);
        4'b1000: ALUres <= A + B;
        4'b1010: ALUres <= A - B;
        4'b1011: ALUres <= (A<B)?1:0;
        endcase
    end

endmodule