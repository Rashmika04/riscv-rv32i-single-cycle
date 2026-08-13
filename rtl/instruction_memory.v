module instruction_memory (
    input  [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] mem [0:255];

    assign instruction = mem[addr[9:2]];

    initial begin
        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00300113; // addi x2, x0, 3
        mem[2] = 32'h002081B3; // add  x3, x1, x2
        mem[3] = 32'h00302023; // sw   x3, 0(x0)
        mem[4] = 32'h00002203; // lw   x4, 0(x0)
        mem[5] = 32'h00000013; // nop
    end

endmodule