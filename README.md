# RISC-V RV32I Single-Cycle Core

A Verilog implementation of a single-cycle RISC-V RV32I processor, developed and verified using Icarus Verilog and GTKWave.

The project implements the processor datapath, control logic, instruction and data memories, branching, and jump instructions, with program-based simulation and automated regression testing.

## Platform and Tools

- **HDL:** Verilog
- **Simulator:** Icarus Verilog
- **Waveform Viewer:** GTKWave
- **IDE:** Visual Studio Code
- **Platform:** MacBook Air M2
- **Architecture:** RISC-V RV32I
- **Author:** Rashmika Peddini

## Processor Architecture

The processor consists of the following major components:

- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File
- Immediate Generator
- ALU
- Branch Unit
- Data Memory
- Next-PC Logic
- Writeback Logic

The processor follows a single-cycle datapath in which each instruction completes within one clock cycle.

## Supported Instructions

### Arithmetic and Logical

- ADD
- SUB
- AND
- OR
- XOR
- SLT
- SLL
- SRL
- SRA

### Immediate

- ADDI
- ANDI
- ORI
- XORI
- SLTI
- SLLI
- SRLI
- SRAI

### Memory

- LW
- SW

### Branch

- BEQ
- BNE

### Jump

- JAL
- JALR

## Project Structure

```text
riscv-rv32i-single-cycle/
│
├── rtl/
│   ├── alu.v
│   ├── branch_unit.v
│   ├── control.v
│   ├── cpu.v
│   ├── data_memory.v
│   ├── imm_gen.v
│   ├── instruction_memory.v
│   └── regfile.v
│
├── tb/
│   ├── cpu_tb.v
│   ├── arithmetic_tb.v
│   ├── immediate_tb.v
│   ├── branch_tb.v
│   ├── memory_tb.v
│   ├── jal_tb.v
│   └── jalr_tb.v
│
├── programs/
│   ├── basic.hex
│   ├── arithmetic.hex
│   ├── immediate.hex
│   ├── branch.hex
│   ├── memory.hex
│   ├── jal.hex
│   └── jalr.hex
│
├── docs/
├── scripts/
├── sim/
├── Makefile
└── README.md
