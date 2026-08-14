IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

PROGRAM ?= basic

RTL = rtl/alu.v rtl/regfile.v rtl/imm_gen.v rtl/control.v \
      rtl/instruction_memory.v rtl/data_memory.v \
      rtl/branch_unit.v rtl/cpu.v

ifeq ($(PROGRAM),basic)
TESTBENCH = tb/cpu_tb.v
else
TESTBENCH = tb/$(PROGRAM)_tb.v
endif

SIM = sim/$(PROGRAM).vvp

.PHONY: all test test-all wave clean

all: test

test:
	mkdir -p sim
	$(IVERILOG) -Wall -DPROGRAM_FILE=\"programs/$(PROGRAM).hex\" -o $(SIM) $(RTL) $(TESTBENCH)
	$(VVP) $(SIM)

test-all:
	@echo "========================================"
	@echo "       RV32I REGRESSION TEST"
	@echo "========================================"
	@$(MAKE) test PROGRAM=basic
	@$(MAKE) test PROGRAM=arithmetic
	@$(MAKE) test PROGRAM=immediate
	@$(MAKE) test PROGRAM=branch
	@$(MAKE) test PROGRAM=memory
	@$(MAKE) test PROGRAM=jal
	@$(MAKE) test PROGRAM=jalr
	@echo "========================================"
	@echo "       REGRESSION COMPLETE"
	@echo "========================================"

wave:
	$(GTKWAVE) sim/$(PROGRAM).vcd &

clean:
	rm -rf sim/*

	