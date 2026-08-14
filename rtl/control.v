`timescale 1ns/1ps
module control (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg       branch,
    output reg       mem_read,
    output reg       mem_to_reg,
    output reg [3:0] alu_op,
    output reg       mem_write,
    output reg       alu_src,
    output reg       reg_write,
    output reg       jump,
    output reg       jalr
);

    always @(*) begin

        // Default control signals
        branch     = 0;
        mem_read   = 0;
        mem_to_reg = 0;
        alu_op     = 4'b0000;
        mem_write  = 0;
        alu_src    = 0;
        reg_write  = 0;
        jump       = 0;
        jalr       = 0;

        case (opcode)

            // =================================================
            // R-type instructions
            // =================================================
            7'b0110011: begin

                reg_write = 1;

                case ({funct7[5], funct3})

                    4'b0000: alu_op = 4'b0000; // ADD
                    4'b1000: alu_op = 4'b0001; // SUB
                    4'b0111: alu_op = 4'b0010; // AND
                    4'b0110: alu_op = 4'b0011; // OR
                    4'b0100: alu_op = 4'b0100; // XOR
                    4'b0010: alu_op = 4'b0101; // SLT
                    4'b0001: alu_op = 4'b0110; // SLL
                    4'b0101: alu_op = 4'b0111; // SRL
                    4'b1101: alu_op = 4'b1000; // SRA

                    default: alu_op = 4'b0000;

                endcase

            end

            // =================================================
            // I-type ALU instructions
            // =================================================
            7'b0010011: begin

                reg_write = 1;
                alu_src   = 1;

                case (funct3)

                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b111: alu_op = 4'b0010; // ANDI
                    3'b110: alu_op = 4'b0011; // ORI
                    3'b100: alu_op = 4'b0100; // XORI
                    3'b010: alu_op = 4'b0101; // SLTI
                    3'b001: alu_op = 4'b0110; // SLLI

                    3'b101: begin
                        if (funct7[5])
                            alu_op = 4'b1000; // SRAI
                        else
                            alu_op = 4'b0111; // SRLI
                    end

                    default: alu_op = 4'b0000;

                endcase

            end

            // =================================================
            // LOAD
            // =================================================
            7'b0000011: begin

                reg_write  = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                alu_src    = 1;
                alu_op     = 4'b0000;

            end

            // =================================================
            // STORE
            // =================================================
            7'b0100011: begin

                mem_write = 1;
                alu_src   = 1;
                alu_op    = 4'b0000;

            end

            // =================================================
            // BRANCH
            // =================================================
            7'b1100011: begin

                branch = 1;
                alu_op = 4'b0001;

            end

            // =================================================
            // JAL
            // =================================================
            7'b1101111: begin

                reg_write = 1;
                jump      = 1;

            end

            // =================================================
            // JALR
            // =================================================
            7'b1100111: begin

                reg_write = 1;
                jalr      = 1;
                alu_src   = 1;

            end

            // =================================================
            // LUI
            // =================================================
            7'b0110111: begin

                reg_write = 1;
                alu_src   = 1;
                alu_op    = 4'b0000;

            end

            default: begin
                // No operation
            end

        endcase

    end

endmodule