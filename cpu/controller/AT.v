module AT (
    input addu, subu, ori, lw, sw, beq, lui, addi, addiu, slt, j, jal, jr,
    output reg Tuse_rs,
    output reg [1:0] Tuse_rt,
    output reg [1:0] Tnew,
    output reg cal_ID, load_ID
);
    always @(*) begin
        // Tuse_rs
        if (addu|subu|addi|addiu|ori|lw|sw|slt) Tuse_rs = 1;
        else if (beq|jr) Tuse_rs = 0;
        else Tuse_rs = 5; // 无关指令设为大值
        // Tuse_rt
        if (sw) Tuse_rt = 2;
        else if (addu|subu|lui|slt) Tuse_rt = 1;
        else if (beq) Tuse_rt = 0;
        else Tuse_rt = 5;
        // Tnew
        if (addu|subu|ori|slt|addi|addiu) Tnew = 1;
        else if (lw) Tnew = 2;
        else Tnew = 0;
        // ctrl signals
        cal_ID = (addu|subu|ori|slt|addi|addiu);
        load_ID = (lw);
    end
endmodule
