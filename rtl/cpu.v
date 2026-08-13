module cpu (
    input         clk,
    input         rst,
    output [31:0] pc_out,
    output [31:0] instr_out
);
    reg [31:0] pc;
    wire [31:0] pc_next;
    reg [31:0] imem [0:255];
    wire [31:0] instruction = imem[pc[9:2]];
    reg [31:0] dmem [0:255];
    wire [31:0] mem_data;
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jump;
    wire [3:0] alu_op;
    wire zero;
    wire [31:0] rs1_data, rs2_data, write_data;
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd  = instruction[11:7];
    wire [31:0] imm;
    wire [31:0] alu_in2 = alu_src ? imm : rs2_data;
    wire [31:0] alu_result;

    control u_ctrl (.opcode(instruction[6:0]), .funct3(instruction[14:12]), .funct7(instruction[31:25]),
                    .branch(branch), .mem_read(mem_read), .mem_to_reg(mem_to_reg),
                    .alu_op(alu_op), .mem_write(mem_write), .alu_src(alu_src),
                    .reg_write(reg_write), .jump(jump));
    regfile u_reg (.clk(clk), .we(reg_write), .rs1(rs1), .rs2(rs2), .rd(rd),
                   .wd(write_data), .rd1(rs1_data), .rd2(rs2_data));
    imm_gen u_imm (.instruction(instruction), .imm(imm));
    alu u_alu (.a(rs1_data), .b(alu_in2), .alu_control(alu_op), .result(alu_result), .zero(zero));

    assign write_data = mem_to_reg ? mem_data : (jump ? (pc + 4) : alu_result);
    assign mem_data = dmem[alu_result[9:2]];
    always @(posedge clk) if (mem_write) dmem[alu_result[9:2]] <= rs2_data;

    assign pc_next = jump ? (pc + imm) : (branch && zero) ? (pc + imm) : (pc + 4);
    always @(posedge clk or posedge rst) begin
        if (rst) pc <= 32'b0;
        else     pc <= pc_next;
    end
    assign pc_out = pc;
    assign instr_out = instruction;

    initial begin
        imem[0] = 32'h00500093; // addi x1, x0, 5
        imem[1] = 32'h00300113; // addi x2, x0, 3
        imem[2] = 32'h002081B3; // add  x3, x1, x2
        imem[3] = 32'h00302023; // sw   x3, 0(x0)
        imem[4] = 32'h00002203; // lw   x4, 0(x0)
        imem[5] = 32'h00000013; // nop
    end
endmodule
