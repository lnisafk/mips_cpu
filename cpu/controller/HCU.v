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
    localparam TUSE_B = 0; // beq 在 ID 级就需要数据
    localparam TUSE_C = 1; // 运算指令 在 EX 级需要数据
    wire stall_rs, stall_rt;
    // 不考虑jal
    assign stall_rs =
        // ID:beq EX:cal/load
        ((cal_EX | load_EX) && (Tuse_rs == TUSE_B) && (A1_ID == A3_EX))
        // ID:beq MEM:load
        || ((load_MEM) && (Tuse_rs == 0) && (A1_ID == A3_MEM))
        // ID:cal EX:load
        || ((load_EX) && (Tuse_rs == 1) && (A1_ID == A3_EX))    
        ?1:0;
    assign stall_rt =  
        ((cal_EX | load_EX) && (Tuse_rt == 0) && (A2_ID == A3_EX))
        || ((load_MEM) && (Tuse_rt == 0) && (A2_ID == A3_MEM))
        || ((load_EX) && (Tuse_rt == 1) && (A2_ID == A3_EX))
        ?1:0;
    always @(*) stall = stall_rs | stall_rt | mem_stall_MEM;
endmodule