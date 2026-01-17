module NPC (
    input  logic [31:0] pc4_ID,
    input  logic [1:0]  PcSrc, // 建议后续也改为 enum
    input  logic        zero,
    input  logic [31:0] Instr_ID,
    input  logic [31:0] Address_r31,
    output logic [31:0] npc
);

    always @(*) begin
        npc = pc4_ID + 4; // 大多数情况，防latch
        case (PcSrc)
            2'd1: begin // beq
                if (zero) npc = pc4_ID + ({{16{Instr_ID[15]}}, Instr_ID[15:0]} << 2);
                else      npc = pc4_ID + 4;
            end
            2'd2: begin // j, jal
                npc = {pc4_ID[31:28], Instr_ID[25:0], 2'b00};
            end
            2'd3: begin // jr
                npc = Address_r31;
            end
            default: begin // pc+4
                npc = pc4_ID + 4;
            end
        endcase
    end
    
endmodule