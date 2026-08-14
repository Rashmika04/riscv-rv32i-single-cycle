`timescale 1ns/1ps

module branch_tb;

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
                $display("[PASS] %-20s | x%0d = %h",
                         name, reg_num,
                         dut.u_reg.registers[reg_num]);
                passed = passed + 1;
            end
            else begin
                $display("[FAIL] %-20s | x%0d | expected=%h got=%h",
                         name, reg_num,
                         expected,
                         dut.u_reg.registers[reg_num]);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("sim/branch.vcd");
        $dumpvars(0, branch_tb);

        passed = 0;
        failed = 0;

        rst = 1;
        #20;
        rst = 0;

        #120;

        // BEQ taken:
        // x1 == x2, therefore x3 instruction is skipped.
        check(3, 32'd0, "BEQ taken");

        // Instruction after the branch executes.
        check(4, 32'd2, "BEQ target");

        // BNE taken:
        // x5 = 1, x2 = 5, therefore branch is taken.
        check(6, 32'd0, "BNE taken");

        // Branch target executes.
        check(7, 32'd9, "BNE target");

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