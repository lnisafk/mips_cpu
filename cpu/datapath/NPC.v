module NPC (
    input [31:0] pc4_ID,
    input [1:0] PcSrc,
    input zero,
    input [31:0] Instr_ID,
    input [31:0] Address_r31,
    output reg [31:0] npc
);
    always@(*) begin
        if (PcSrc == 1 && zero)
            npc <= pc4_ID + (Instr_ID[15:0] << 2);
        else if (PcSrc == 2)
            npc <= {pc4_ID[31:28], Instr_ID[25:0], 2'b0}; 
        else if (PcSrc == 3)
            npc <= Address_r31;
        else
            npc <= pc4_ID + 4;
    end
    
endmodule