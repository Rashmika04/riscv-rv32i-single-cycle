`timescale 1ns/1ps

module jal_tb;

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

    task check_register;
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
                         name, reg_num, expected,
                         dut.u_reg.registers[reg_num]);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("sim/jal.vcd");
        $dumpvars(0, jal_tb);

        passed = 0;
        failed = 0;

        rst = 1;
        #20;
        rst = 0;

        #80;

        // JAL should save PC+4 (8) into x1.
        check_register(1, 32'd8, "JAL link address");

        // Instruction after JAL should be skipped.
        check_register(2, 32'd0, "JAL skipped instruction");

        // JAL target should execute.
        check_register(3, 32'd3, "JAL target");

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