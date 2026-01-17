module IM (
    input [31:0] pc,
    output [31:0] Instr
);
    reg [31:0] ROM[0:31];
    initial $readmemh("code.txt", ROM);
    assign Instr = ROM[pc[6:2]];
endmodule