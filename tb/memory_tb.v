`timescale 1ns/1ps

module memory_tb;

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

    task check_memory;
        input [7:0] address;
        input [31:0] expected;
        input [127:0] name;

        begin
            if (dut.u_dmem.mem[address] === expected) begin
                $display("[PASS] %-20s | MEM[%0d] = %h",
                         name, address,
                         dut.u_dmem.mem[address]);
                passed = passed + 1;
            end
            else begin
                $display("[FAIL] %-20s | MEM[%0d] | expected=%h got=%h",
                         name, address, expected,
                         dut.u_dmem.mem[address]);
                failed = failed + 1;
            end
        end
    endtask

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

        $dumpfile("sim/memory.vcd");
        $dumpvars(0, memory_tb);

        passed = 0;
        failed = 0;

        rst = 1;
        #20;
        rst = 0;

        #100;

        // Check stores
        check_memory(0, 32'd10, "SW address 0");
        check_memory(1, 32'd20, "SW address 1");

        // Check loads
        check_register(3, 32'd10, "LW x3");
        check_register(4, 32'd20, "LW x4");

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