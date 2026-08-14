# RISC-V RV32I Single-Cycle Processor

A complete single-cycle RISC-V RV32I processor implemented in Verilog and verified using automated instruction-level testbenches and GTKWave waveform analysis.

**Author:** Rashmika Peddini  
**Platform:** MacBook Air M2  
**HDL:** Verilog  
**Simulation:** Icarus Verilog  
**Waveform Analysis:** GTKWave  
**Development:** VS Code

---

## Overview

This project implements a modular single-cycle RISC-V processor based on the RV32I instruction set.

The processor contains separate modules for:

- Arithmetic Logic Unit (ALU)
- Register File
- Immediate Generator
- Control Unit
- Instruction Memory
- Data Memory
- Branch Unit
- Program Counter / CPU datapath

The design was developed incrementally and verified using dedicated testbenches for different instruction classes.

---

## Implemented Features

### Arithmetic and Logical Instructions

- `ADD`
- `SUB`
- `AND`
- `OR`
- `XOR`
- `SLT`
- `SLL`
- `SRL`
- `SRA`

### Immediate Instructions

- `ADDI`
- `ANDI`
- `ORI`
- `XORI`
- `SLTI`
- `SLLI`
- `SRLI`
- `SRAI`

### Branch Instructions

- `BEQ`
- `BNE`

### Memory Instructions

- `LW`
- `SW`

### Jump Instructions

- `JAL`
- `JALR`

---

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
│   ├── arithmetic_tb.v
│   ├── branch_tb.v
│   ├── cpu_tb.v
│   ├── immediate_tb.v
│   ├── jal_tb.v
│   ├── jalr_tb.v
│   └── memory_tb.v
│
├── programs/
│   ├── arithmetic.hex
│   ├── basic.hex
│   ├── branch.hex
│   ├── immediate.hex
│   ├── jal.hex
│   ├── jalr.hex
│   └── memory.hex
│
├── docs/
│   └── screenshots/
│       ├── arithmetic_waveform.png
│       └── processor_execution.png
│
├── Makefile
├── README.md
└── .gitignore

