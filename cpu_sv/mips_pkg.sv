package mips_pkg;
    // 定义 ALU 控制信号的枚举类型
    typedef enum logic [3:0] {
        ALU_AND  = 4'b0000,
        ALU_OR   = 4'b0001,
        ALU_ADD  = 4'b0010,
        ALU_SUB  = 4'b0110,
        ALU_SLT  = 4'b0111,
        ALU_NOR  = 4'b1100,
        ALU_ADDU = 4'b1000,
        ALU_SUBU = 4'b1010,
        ALU_SLTU = 4'b1011
    } alu_op_t;

    // 你也可以在这里定义操作码等其他常量
endpackage