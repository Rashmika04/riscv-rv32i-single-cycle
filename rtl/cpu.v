`timescale 1ns/1ps
module cpu (
    input         clk,
    input         rst,
    output [31:0] pc_out,
    output [31:0] instr_out
);

    // ============================================================
    // Program Counter
    // ============================================================

    reg [31:0] pc;
    wire [31:0] pc_next;


    // ============================================================
    // Instruction Memory
    // ============================================================

    wire [31:0] instruction;

    instruction_memory u_imem (
        .addr(pc),
        .instruction(instruction)
    );


    // ============================================================
    // Instruction Fields
    // ============================================================

    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd  = instruction[11:7];

    wire [2:0] funct3 = instruction[14:12];


    // ============================================================
    // Control Unit
    // ============================================================

    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire mem_write;
    wire alu_src;
    wire reg_write;
    wire jump;
    wire jalr;

    wire [3:0] alu_op;

    control u_ctrl (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),

        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump),
        .jalr(jalr)
    );


    // ============================================================
    // Register File
    // ============================================================

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] write_data;

    regfile u_reg (
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_data),
        .rd1(rs1_data),
        .rd2(rs2_data)
    );


    // ============================================================
    // Immediate Generator
    // ============================================================

    wire [31:0] imm;

    imm_gen u_imm (
        .instruction(instruction),
        .imm(imm)
    );


    // ============================================================
    // ALU
    // ============================================================

    wire [31:0] alu_in2;
    wire [31:0] alu_result;
    wire zero;

    assign alu_in2 = alu_src ? imm : rs2_data;

    alu u_alu (
        .a(rs1_data),
        .b(alu_in2),
        .alu_control(alu_op),
        .result(alu_result),
        .zero(zero)
    );


    // ============================================================
    // Branch Unit
    // ============================================================

    wire branch_taken;

    branch_unit u_branch (
        .funct3(funct3),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch_taken(branch_taken)
    );


    // ============================================================
    // Data Memory
    // ============================================================

    wire [31:0] mem_data;

    data_memory u_dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(alu_result),
        .write_data(rs2_data),
        .read_data(mem_data)
    );


    // ============================================================
    // Writeback
    // ============================================================

    assign write_data =
        mem_to_reg ? mem_data :
        (jump || jalr) ? (pc + 32'd4) :
        alu_result;


    // ============================================================
    // Next PC Logic
    // ============================================================

    assign pc_next =
        jump ? (pc + imm) :
        jalr ? ((rs1_data + imm) & 32'hFFFFFFFE) :
        (branch && branch_taken) ? (pc + imm) :
        (pc + 32'd4);


    // ============================================================
    // Program Counter Register
    // ============================================================

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0;
        else
            pc <= pc_next;
    end


    // ============================================================
    // Outputs
    // ============================================================

    assign pc_out    = pc;
    assign instr_out = instruction;

endmodule