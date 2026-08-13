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
    output reg       jump
);
    always @(*) begin
        branch = 0; mem_read = 0; mem_to_reg = 0; alu_op = 4'b0000;
        mem_write = 0; alu_src = 0; reg_write = 0; jump = 0;
        case (opcode)
            7'b0110011: begin
                reg_write = 1;
                case ({funct7[5], funct3})
                    4'b0000: alu_op = 4'b0000;
                    4'b1000: alu_op = 4'b0001;
                    4'b0111: alu_op = 4'b0010;
                    4'b0110: alu_op = 4'b0011;
                    4'b0100: alu_op = 4'b0100;
                    4'b0010: alu_op = 4'b0101;
                    4'b0001: alu_op = 4'b0110;
                    4'b0101: alu_op = (funct7[5]) ? 4'b1000 : 4'b0111;
                    default: alu_op = 4'b0000;
                endcase
            end
            7'b0010011: begin
                reg_write = 1; alu_src = 1;
                case (funct3)
                    3'b000: alu_op = 4'b0000;
                    3'b111: alu_op = 4'b0010;
                    3'b110: alu_op = 4'b0011;
                    3'b100: alu_op = 4'b0100;
                    3'b010: alu_op = 4'b0101;
                    3'b001: alu_op = 4'b0110;
                    3'b101: alu_op = (funct7[5]) ? 4'b1000 : 4'b0111;
                    default: alu_op = 4'b0000;
                endcase
            end
            7'b0000011: begin
                reg_write = 1; mem_read = 1; mem_to_reg = 1; alu_src = 1; alu_op = 4'b0000;
            end
            7'b0100011: begin
                mem_write = 1; alu_src = 1; alu_op = 4'b0000;
            end
            7'b1100011: begin
                branch = 1; alu_op = 4'b0001;
            end
            7'b1101111: begin
                reg_write = 1; jump = 1;
            end
            7'b0110111: begin
                reg_write = 1; alu_src = 1; alu_op = 4'b0000;
            end
            default: ;
        endcase
    end
endmodule
