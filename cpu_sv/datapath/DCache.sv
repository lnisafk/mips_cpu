module DCache (
    input  logic        clk, rst,
    input  logic        MemWrite,
    input  logic [1:0]  MemtoReg,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    output logic        ready,
    // 主存接口
    output logic [31:0] mem_addr,
    input  logic [31:0] mem_rdata
);
    parameter NUM_LINES = 32;   // 32块，总大小32×4字=128字=512B
    parameter BLOCK_WORDS = 4;  // 每块4字（16字节）
    
    localparam INDEX_BITS  = 5; // 索引位数（索引32行 → 5位）
    localparam OFFSET_BITS = 2; // 块内偏移位数（索引4字 → 2位）
    localparam TAG_BITS    = 23;// 标记位数（30-5-2=23位）
    /* 32位地址：标记——行号——块内地址
    根据行号找cache_line，比较该行标记
    如果相等&有效位为1- 根据块内地址读cache
        不等|有效位为0- 从RAM读地址所在块，送对应cache_line中，
                        有效位置1，标记设置为地址中高t位
    */
    // cache line
    logic [TAG_BITS-1:0] tag   [NUM_LINES-1:0]; // 32个块，每个有23位标记
    logic [31:0]         data  [NUM_LINES-1:0][BLOCK_WORDS-1:0];    // 32个块*每块4个字，每个单元32位
    logic                valid [NUM_LINES-1:0]; // 32个块，每个有1位有效位

    // addr decode
    logic [OFFSET_BITS-1:0] offset; // 块内字偏移（[3:2]）
    logic [INDEX_BITS-1:0]  index;  // 索引（[8:4]）
    logic [TAG_BITS-1:0]    tag_in; // 标签（[31:9]）

    assign offset = addr[3:2];
    assign index  = addr[8:4];
    assign tag_in = addr[31:9]; // 高23位

    // Hit
    logic hit;
    assign hit = valid[index] && (tag[index] == tag_in);
    
    // 写，或读命中，或者是不用读存储器的指令(MemtoReg!=1)，则ready
    assign ready = (MemWrite) ? 1'b1 :
                   (MemtoReg != 1) ? 1'b1 :
                   hit;

    // FSM
    typedef enum logic {IDLE, MISS} state_t;
    state_t state;
    
    logic [2:0] load_counter;   // 块加载计数器 到4为止

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < NUM_LINES; i++) begin
                valid[i] <= '0;
                tag[i]   <= '0;
            end
            state <= IDLE;
            load_counter <= '0;
            mem_addr <= '0;
            rdata <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (MemWrite) begin
                        // Write Through
                        if (hit) data[index][offset] <= wdata;
                        $display("Write through. index: %h wdata: %h", index, wdata);
                    end else if (MemtoReg == 1) begin
                        if (hit) begin
                            rdata <= data[index][offset];
                            $display("Hit. index: %h rdata: %h", index, data[index][offset]);
                        end else begin
                            state <= MISS;
                            // 缺失，准备从主存读取块
                            // 块对齐地址: {tag, index, 00..00}
                            mem_addr <= {addr[31:4], 4'b0000}; 
                            load_counter <= '0;
                            $display("Miss. index: %h tag_in: %h", index, tag_in);
                        end
                    end
                end

                MISS: begin
                    // 简单的突发读取模拟，每周期读一个字
                    if (load_counter < BLOCK_WORDS) begin
                        data[index][load_counter] <= mem_rdata;
                        mem_addr <= mem_addr + 4; // 读下一个字
                        load_counter <= load_counter + 1;
                        $display("Loading block... data: %h", mem_rdata);
                    end else begin
                        // 加载完成
                        valid[index] <= 1'b1;
                        tag[index]   <= tag_in;
                        state        <= IDLE;
                        // 这里可以优化：直接把请求的数据送给 rdata，而不是回到 IDLE 再等一周期
                        rdata        <= data[index][offset]; 
                        $display("Block loaded. Back to IDLE.");
                    end
                end
            endcase
        end
    end
endmodule