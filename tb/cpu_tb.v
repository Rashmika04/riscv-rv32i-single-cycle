`timescale 1ns/1ps
`timescale 1ns/1ps

module cpu_tb;

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

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Check register value
    task check_register;
        input [4:0] reg_num;
        input [31:0] expected;
        input [127:0] test_name;

        begin
            if (dut.u_reg.registers[reg_num] === expected) begin
                $display("[PASS] %s | x%0d = %0d",
                         test_name, reg_num, expected);
                passed = passed + 1;
            end
            else begin
                $display("[FAIL] %s | x%0d | expected = %0d, got = %0d",
                         test_name,
                         reg_num,
                         expected,
                         dut.u_reg.registers[reg_num]);
                failed = failed + 1;
            end
        end
    endtask

    // Check data memory
    task check_memory;
        input [31:0] address;
        input [31:0] expected;
        input [127:0] test_name;

        begin
            if (dut.u_dmem.mem[address[9:2]] === expected) begin
                $display("[PASS] %s | MEM[%0d] = %0d",
                         test_name, address, expected);
                passed = passed + 1;
            end
            else begin
                $display("[FAIL] %s | MEM[%0d] | expected = %0d, got = %0d",
                         test_name,
                         address,
                         expected,
                         dut.u_dmem.mem[address[9:2]]);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        passed = 0;
        failed = 0;

        $dumpfile("sim/cpu.vcd");
        $dumpvars(0, cpu_tb);

        $display("");
        $display("========================================");
        $display("       RV32I CPU VERIFICATION");
        $display("========================================");
        $display("");

        // Reset CPU
        rst = 1;

        #20;

        rst = 0;

        // Allow all six instructions to execute.
        // Clock edges occur every 10 ns.
        #100;

        // ----------------------------------------
        // Register checks
        // ----------------------------------------

        check_register(5'd1, 32'd5, "ADDI x1");
        check_register(5'd2, 32'd3, "ADDI x2");
        check_register(5'd3, 32'd8, "ADD x3");
        check_register(5'd4, 32'd8, "LW x4");

        // ----------------------------------------
        // Memory check
        // ----------------------------------------

        check_memory(32'd0, 32'd8, "SW");

        // ----------------------------------------
        // Summary
        // ----------------------------------------

        $display("");
        $display("========================================");
        $display("RESULT: %0d / %0d TESTS PASSED",
                 passed, passed + failed);
        $display("========================================");

        if (failed == 0)
            $display("STATUS: PASS");
        else
            $display("STATUS: FAIL");

        $display("");
        $display("Final PC = %h", pc);
        $display("");

        $finish;

    end

endmodule
