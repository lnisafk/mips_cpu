module Stage_IF (
    input  logic        clk, rst, stall,
    input  logic [1:0]  PcSrc,
    input  logic [31:0] Address_ID,
    output logic [31:0] Instr_IF,
    output logic [31:0] pc4_IF
);

    logic [31:0] pc, npc;

    assign pc4_IF = pc + 4;

    always_comb begin
        case (PcSrc)
            2'd0: npc = pc4_IF;
            default: npc = Address_ID; // beq, j, jr 都在ID阶段计算好地址传过来
        endcase
    end

    always_ff @(posedge clk) begin
        if (!stall && !rst) 
            $display("PC: %h \"%h\" NPC: %h", pc, Instr_IF, npc);
    end

    PC u_PC (
        .clk(clk), .rst(rst), .stall(stall),
        .npc(npc), .pc(pc)
    );

    IM u_IM (
        .pc(pc), 
        .Instr(Instr_IF)
    );

endmodule