module AT (
    input  logic addu, subu, ori, lw, sw, beq, lui, addi, addiu, slt, j, jal, jr,
    output logic         Tuse_rs,
    output logic [1:0]   Tuse_rt,
    output logic [1:0]   Tnew,
    output logic         cal_ID, 
    output logic         load_ID
);

    always_comb begin
        // Tuse_rs: 什么时候需要rs的值？
        if (beq | jr)                                   Tuse_rs = 1'b0; // ID阶段需要
        else if (addu|subu|addi|addiu|ori|lw|sw|slt)    Tuse_rs = 1'b1; // EX阶段需要
        else                                            Tuse_rs = 1'b1; // 无关

        // Tuse_rt: 什么时候需要rt寄存器的值？
        if (beq)                                        Tuse_rt = 2'd0; // ID阶段需要
        else if (addu|subu|lui|slt)                     Tuse_rt = 2'd1; // EX阶段需要
        else if (sw)                                    Tuse_rt = 2'd2; // MEM阶段需要
        else                                            Tuse_rt = 2'd3; // 无关

        // Tnew: 结果在哪个阶段产生？
        // 1: EX阶段产生(ALU结果)
        // 2: MEM阶段产生(lw)
        // 0: 不写回或ID阶段(jal,lui)
        if (addu|subu|ori|slt|addi|addiu) Tnew = 2'd1;
        else if (lw)                      Tnew = 2'd2;
        else                              Tnew = 2'd0;

        // debug
        cal_ID  = (addu|subu|ori|slt|addi|addiu); // 计算类指令
        load_ID = (lw);                           // 加载类指令
    end

endmodule