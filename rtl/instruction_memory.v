`timescale 1ns/1ps
module instruction_memory (
    input  [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] mem [0:255];
    integer i;

    assign instruction = mem[addr[9:2]];

    initial begin

        // Initialize unused instruction memory with NOPs.
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'h00000013;

`ifdef PROGRAM_FILE

        $display("Loading program: %s", `PROGRAM_FILE);
        $readmemh(`PROGRAM_FILE, mem);

`else

        $display("Loading program: programs/basic.hex");
        $readmemh("programs/basic.hex", mem);

`endif

    end

endmodule