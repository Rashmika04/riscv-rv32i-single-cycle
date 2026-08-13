IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

RTL = rtl/alu.v rtl/regfile.v rtl/imm_gen.v rtl/control.v rtl/cpu.v
TB  = tb/cpu_tb.v

all: sim

sim:
	mkdir -p sim
	$(IVERILOG) -o sim/cpu.vvp $(RTL) $(TB)
	$(VVP) sim/cpu.vvp
	@echo "Simulation completed. Waveform: sim/cpu.vcd"

wave:
	$(GTKWAVE) sim/cpu.vcd &

clean:
	rm -rf sim/*

.PHONY: all sim wave clean