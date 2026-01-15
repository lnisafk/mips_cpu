`timescale 1ns / 1ps
module DCache (
    input clk, rst,
    input MemWrite,
    input [1:0] MemtoReg,
    input [31:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata,
    output ready,
    // 主存接口
    output reg [31:0] mem_addr,
    input  [31:0] mem_rdata
);
    parameter NUM_LINES = 32;   // 32块，总大小32×4字=128字=512B
    parameter BLOCK_WORDS = 4;  // 每块4字（16字节）
    localparam INDEX_BITS = 5;  // 索引位数（索引32行 → 5位）
    localparam OFFSET_BITS = 2; // 块内偏移位数（索引4字 → 2位）
    localparam TAG_BITS = 23;   // 标记位数（30-5-2=23位）
    /* 32位地址：标记——行号——块内地址
    根据行号找cache_line，比较该行标记
    如果相等&有效位为1-根据块内地址读cache
        不等|有效位为0-从RAM读地址所在块，送对应cache_line中，有效位置1，标记设置为地址中高t位
    */
    reg [TAG_BITS-1:0] tag [NUM_LINES-1:0];             // 32个块，每个有23位标记
    reg [31:0] data [NUM_LINES-1:0][BLOCK_WORDS-1:0];   // 32个块*每块4个字，每个单元32位
    reg valid [NUM_LINES-1:0];                          // 32个块，每个有1位有效位
    // 本设计中只使用低12位地址
    wire [OFFSET_BITS-1:0] offset = addr[3:2];         // 块内字偏移（[3:2]）
    wire [INDEX_BITS-1:0]  index = addr[8:4];          // 索引（[8:4]）
    wire [TAG_BITS-1:0]    tag_in = addr[11:9];        // 标签（[31:9]）
    reg state;              // 状态机 
    parameter IDLE = 0;
    parameter MISS = 1;
    reg [2:0] load_counter; // 块加载计数器 到4为止
    wire hit = valid[index] && (tag[index] == tag_in);  // 命中：索引对应有效位为1、标记相同
    assign ready = hit || (MemtoReg != 1);              // 666 读不命中->阻塞
    integer i;
    always@(posedge clk) begin
        if (rst) begin // 复位：每个块对应的标记和有效位清空
            for (i = 0; i < NUM_LINES; i = i + 1) begin
                valid[i] <= 0;
                tag[i] <= 0;
            end
            state <= IDLE;
            load_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (MemWrite) begin
                        if (hit) data[index][offset] <= wdata; // 写直达
                        $display("Write through. index: %b wdata: %h", index, wdata);
                    end else if (MemtoReg == 1) begin
                        if (hit) begin
                            rdata <= data[index][offset];
                            $display("Hit. index: %b rdata: %h", index, rdata);
                        end else begin
                            state <= MISS;
                            mem_addr <= {addr[11:4], 4'b0000}; // 主存块开头地址
                            load_counter <= 0;
                            $display("Miss. index: %b", index);
                        end
                    end
                end
                MISS: begin
                    if (load_counter < BLOCK_WORDS) begin
                        data[index][load_counter] <= mem_rdata;
                        mem_addr <= mem_addr + 4;
                        load_counter <= load_counter + 1;
                        $display("%b loaded. data: %h", mem_addr, mem_rdata);
                    end else begin
                        valid[index] <= 1;
                        tag[index] <= tag_in;
                        state <= IDLE;
                        rdata <= data[index][offset];
                        $display("Block %b loaded.", index);
                    end
                end
            endcase
        end
    end
endmodule