`timescale 1ns/1ps

module cpu_tb;
    reg clk;
    reg rst;
    wire [31:0] pc;
    wire [31:0] instr;

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

    initial begin
        $dumpfile("sim/cpu.vcd");
        $dumpvars(0, cpu_tb);

        rst = 1;
        #20;
        rst = 0;

        #300;

        $display("Simulation finished");
        $display("Final PC = %h", pc);
        $finish;
    end
endmodule
