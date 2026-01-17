module HCU (
    input  logic       mem_stall_MEM,
    input  logic       Tuse_rs,
    input  logic [1:0] Tuse_rt,
    // ID级指令的Tuse，与后续流水级的Tnew比较
    input  logic       cal_EX, load_EX, load_MEM,
    input  logic [4:0] A3_EX, A3_MEM, A1_ID, A2_ID,
    output logic       stall
);

    logic stall_rs, stall_rt;

    always_comb begin
        // rs冒险检测
        // 1. ID是beq(Tuse=0),EX是运算(Tnew=1)->stall
        // 2. ID是beq(Tuse=0),MEM是lw(Tnew=2)->stall
        // 3. ID是运算(Tuse=1),EX是lw(Tnew=2)->stall
        
        stall_rs = 0;
        if (A1_ID != 0) begin
            if ((cal_EX | load_EX) && (Tuse_rs == 0) && (A1_ID == A3_EX))  stall_rs = 1;
            else if ((load_MEM)    && (Tuse_rs == 0) && (A1_ID == A3_MEM)) stall_rs = 1;
            else if ((load_EX)     && (Tuse_rs == 1) && (A1_ID == A3_EX))  stall_rs = 1;
        end

        // rt冒险检测
        stall_rt = 0;
        if (A2_ID != 0) begin
            if ((cal_EX | load_EX) && (Tuse_rt == 0) && (A2_ID == A3_EX))  stall_rt = 1;
            else if ((load_MEM)    && (Tuse_rt == 0) && (A2_ID == A3_MEM)) stall_rt = 1;
            else if ((load_EX)     && (Tuse_rt == 1) && (A2_ID == A3_EX))  stall_rt = 1;
        end

        // 汇总 stall 信号
        stall = stall_rs | stall_rt | mem_stall_MEM;
    end

endmodule