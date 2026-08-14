`timescale 1ns/1ps

module immediate_tb;

    reg clk;
    reg rst;

    wire [31:0] pc;
    wire [31:0] instr;

    integer passed;
    integer failed;

    cpu dut (
        .clk(clk),
        .rst(rst),
        .pc_out(pc),
        .instr_out(instr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check;
        input [4:0] reg_num;
        input [31:0] expected;
        input [127:0] name;

        begin
            if (dut.u_reg.registers[reg_num] === expected) begin
                $display("[PASS] %-15s | x%0d = %h",
                         name, reg_num,
                         dut.u_reg.registers[reg_num]);
                passed = passed + 1;
            end
            else begin
                $display("[FAIL] %-15s | x%0d | expected=%h got=%h",
                         name, reg_num, expected,
                         dut.u_reg.registers[reg_num]);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sim/immediate.vcd");
        $dumpvars(0, immediate_tb);

        passed = 0;
        failed = 0;

        rst = 1;
        #20;
        rst = 0;

        #100;

        check(1, 32'd5,  "ADDI");
check(2, 32'd1,  "ANDI");
check(3, 32'd15, "ORI");
check(4, 32'd10, "XORI");
check(5, 32'd1,  "SLTI");
check(6, 32'd10, "SLLI");
check(7, 32'd2,  "SRLI");
check(8, 32'd2,  "SRAI");

        $display("");
        $display("========================================");
        $display("RESULT: %0d / %0d TESTS PASSED",
                 passed, passed + failed);
        $display("========================================");

        if (failed == 0)
            $display("STATUS: PASS");
        else
            $display("STATUS: FAIL");

        $finish;
    end

endmodule