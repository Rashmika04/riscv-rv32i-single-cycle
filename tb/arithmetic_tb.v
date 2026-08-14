`timescale 1ns/1ps
`timescale 1ns/1ps

module arithmetic_tb;

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

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_register;
        input [4:0] reg_num;
        input [31:0] expected;
        input [127:0] test_name;

        begin
            if (dut.u_reg.registers[reg_num] === expected) begin
                $display("[PASS] %-20s | x%0d = %h",
                         test_name, reg_num,
                         dut.u_reg.registers[reg_num]);
                passed = passed + 1;
            end
            else begin
                $display("[FAIL] %-20s | x%0d | expected=%h got=%h",
                         test_name,
                         reg_num,
                         expected,
                         dut.u_reg.registers[reg_num]);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("sim/arithmetic.vcd");
        $dumpvars(0, arithmetic_tb);

        passed = 0;
        failed = 0;

        $display("");
        $display("==============================================");
        $display("       RV32I ARITHMETIC VERIFICATION");
        $display("==============================================");
        $display("");

        rst = 1;
        #20;
        rst = 0;

        // Allow program to execute.
        #120;

        check_register(1,  32'd5,          "ADDI x1");
        check_register(2,  32'd3,          "ADDI x2");
        check_register(3,  32'd8,          "ADD x3");
        check_register(4,  32'hFFFFFFFE,  "SUB x4");
        check_register(5,  32'd1,          "AND x5");
        check_register(6,  32'd7,          "OR x6");
        check_register(7,  32'd6,          "XOR x7");
        check_register(8,  32'd0,          "SLT x8");
        check_register(9,  32'd40,         "SLL x9");
        check_register(10, 32'd0,          "SRL x10");
        check_register(11, 32'd0,          "SRA x11");

        $display("");
        $display("==============================================");
        $display("RESULT: %0d / %0d TESTS PASSED",
                 passed, passed + failed);
        $display("==============================================");

        if (failed == 0)
            $display("STATUS: PASS");
        else
            $display("STATUS: FAIL");

        $display("");

        $finish;
    end

endmodule