module data_memory (
    input         clk,
    input         mem_write,
    input         mem_read,
    input  [31:0] addr,
    input  [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] mem [0:255];

    assign read_data = mem_read ? mem[addr[9:2]] : 32'b0;

    always @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= write_data;
    end

endmodule