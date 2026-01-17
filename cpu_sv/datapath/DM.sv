module DM(
    input  logic        clk, rst,
    input  logic        MemWrite,
    input  logic [31:0] Wd, raddr, waddr,
    output logic [31:0] Rd
);
    logic [31:0] RAM [1023:0];

    // read
    assign Rd = RAM[raddr[11:2]];

    // write
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 1024; i++) begin
                RAM[i] <= '0;
            end
        end else if (MemWrite) begin
            RAM[waddr[11:2]] <= Wd;
            $display("DM  -- @%h <= %h", waddr, Wd);    
        end
    end
endmodule