module decode(
    input  logic [31:0] Instr_ID,
    output logic addu, subu, ori, lw, sw, beq, lui, addi, addiu, slt, j, jal, jr,
    output logic [4:0]  A1, A2,
    output logic [4:0]  A3
);
    logic R;
    logic [5:0] op, funct;

    assign op    = Instr_ID[31:26];
    assign funct = Instr_ID[5:0];
    assign R     = (op == 6'b000000);

    // 指令解码
    assign addu  = R & (funct == 6'b100001);
    assign subu  = R & (funct == 6'b100011);
    assign jr    = R & (funct == 6'b001000);
    assign slt   = R & (funct == 6'b101010);
    
    assign addi  = (op == 6'b001000);
    assign addiu = (op == 6'b001001);
    assign j     = (op == 6'b000010);
    assign jal   = (op == 6'b000011);
    assign ori   = (op == 6'b001101);
    assign lw    = (op == 6'b100011);
    assign sw    = (op == 6'b101011);
    assign beq   = (op == 6'b000100);
    assign lui   = (op == 6'b001111);

    assign A1 = Instr_ID[25:21];
    assign A2 = Instr_ID[20:16];

    // 目标寄存器选择逻辑
    always @(*) begin
        if (addu | subu | slt)                    A3 = Instr_ID[15:11]; // R
        else if (ori | lw | lui | addi | addiu)   A3 = Instr_ID[20:16]; // I
        else if (jal)                             A3 = 5'd31;           // jal写$31
        else                                      A3 = 5'd0;
    end

endmodule