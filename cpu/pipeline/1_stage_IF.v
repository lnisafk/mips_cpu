module Stage_IF (
    input [1:0] PcSrc,
    input [31:0] Address_ID,
    input clk, rst, stall,
    output [31:0] Instr_IF,
    output [31:0] pc4_IF
);
    wire [31:0] npc, pc;
    assign pc4_IF = pc + 4;
    assign npc = (PcSrc == 0) ? pc4_IF : Address_ID;
    always @(posedge clk) begin
        if (!stall) $display("PC: %h \"%h\" NPC: %h", pc, Instr_IF, npc);
    end
    PC PC(
        .clk(clk), .rst(rst), .stall(stall),
        .npc(npc), .pc(pc)
    );
    IM IM(
        .pc(pc), 
        .Instr(Instr_IF)
    );
endmodule