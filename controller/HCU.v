// Tnew > Tuse ? stall : 正常执行
module HCU (
    input mem_stall_MEM,
    input Tuse_rs,
    input [1:0] Tuse_rt,
    // input [1:0] Tnew_EX, Tnew_MEM,
    input cal_EX, load_EX, load_MEM,
    input [4:0] A3_EX, A3_MEM, A1_ID, A2_ID,
    output reg stall
);
    wire stall_rs, stall_rt;
    // 不考虑jal
    assign stall_rs =  ((cal_EX | load_EX)
                        && (Tuse_rs == 0)       // ID:beq 上条是cal或load
                        && (A1_ID == A3_EX))
                    || ((load_MEM)
                        && (Tuse_rs == 0)
                        && (A1_ID == A3_MEM))   // ID:beq 上上条是load
                    || ((load_EX)
                        && (Tuse_rs == 1)
                        && (A1_ID == A3_EX))    // ID:cal 上条是load
                    ?1:0;
    assign stall_rt =  ((cal_EX | load_EX)
                        && (Tuse_rt == 0)
                        && (A2_ID == A3_EX))
                    || ((load_MEM)
                        && (Tuse_rt == 0)
                        && (A2_ID == A3_MEM))
                    || ((load_EX)
                        && (Tuse_rt == 1)
                        && (A2_ID == A3_EX))
                    ?1:0;
    always @(*) stall <= stall_rs | stall_rt | mem_stall_MEM;
endmodule