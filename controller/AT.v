module AT (
    input addu, subu, ori, lw, sw, beq, lui, addi, addiu, slt, j, jal, jr,
    output reg Tuse_rs,
    output reg [1:0] Tuse_rt,
    output reg [1:0] Tnew,
    output reg cal_ID, load_ID
);
    always @(*) begin
        Tuse_rs <= (addu|subu|addi|addiu|ori|lw|sw|slt)?1:(beq|jr)?0:5;
        Tuse_rt <= sw?2:(addu|subu|lui|slt)?1:beq?0:5;
        Tnew <= (addu|subu|ori|slt|addi|addiu)?1:lw?2:0;
        cal_ID <= (addu|subu|ori|slt|addi|addiu)?1:0;
        load_ID <= lw?1:0;
    end
endmodule
