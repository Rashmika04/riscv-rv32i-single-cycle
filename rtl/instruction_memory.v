module instruction_memory #(
    parameter PROGRAM_FILE = "programs/basic.hex"
)(
    input  [31:0] addr,
    output [31:0] instruction
);

    reg [31:0] mem [0:255];

    integer i;

    assign instruction = mem[addr[9:2]];

    initial begin

        // Initialize memory with NOPs.
        // This prevents undefined instructions after the
        // loaded program ends.
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'h00000013;

        // Load program from external hexadecimal file.
        $readmemh(PROGRAM_FILE, mem, 0, 5);

    end

endmodule
