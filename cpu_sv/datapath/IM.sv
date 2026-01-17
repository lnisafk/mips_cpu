module IM (
    input  logic [31:0] pc,
    output logic [31:0] Instr
);
    logic [31:0] ROM[0:1023];

    initial begin
        $readmemh("code.txt", ROM);
    end

    // Word aligned read
    assign Instr = ROM[pc[11:2]]; 
endmodule