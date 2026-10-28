
# DFT and ATPG for a 4-Bit Counter

## Overview

This project demonstrates basic Design for Test (DFT) concepts and Automatic Test Pattern Generation (ATPG) principles using a 4-bit synchronous counter and SystemVerilog testbenches.

The project compares a fault-free counter with a faulty counter to demonstrate fault detection through simulation.

## Objectives

- Design and simulate a 4-bit synchronous counter.
- Understand stuck-at fault modeling.
- Compare fault-free and faulty circuit outputs.
- Identify test patterns that expose a fault.
- Analyze simulation waveforms using GTKWave.

## Tools Used

- SystemVerilog
- Icarus Verilog
- GTKWave
- Ubuntu on WSL
- Visual Studio Code

## Project Structure

```text
dft_atpg_counter/
├── design/
│   ├── counter_4bit.sv
│   └── counter_4bit_faulty.sv
├── tb/
│   ├── tb_dft_atpg.sv
│   └── tb_atpg_fault.sv
├── sim/
├── images/
│   └── atpg_waveform.png
├── README.md
└── .gitignore
```

## Design Description

The fault-free counter increments on each rising clock edge when enabled and resets to zero when reset is asserted.

The faulty counter models a stuck-at-0 fault on output bit 0. Its internal counter operates normally, but the least significant output bit is forced to zero.

## Fault Detection Methodology

The testbench applies a sequence of clock and enable patterns to both counters and compares their outputs.

When the fault-free counter reaches an odd value, bit 0 should be one. The faulty counter forces that bit to zero, exposing the fault.

## Simulation Commands

Compile the fault-free counter testbench:

```bash
iverilog -g2012 -o sim/dft_atpg_sim design/counter_4bit.sv tb/tb_dft_atpg.sv
```

Run:

```bash
vvp sim/dft_atpg_sim
```

Compile the fault-detection testbench:

```bash
iverilog -g2012 -o sim/atpg_fault_sim design/counter_4bit.sv design/counter_4bit_faulty.sv tb/tb_atpg_fault.sv
```

Run:

```bash
vvp sim/atpg_fault_sim
```

View the waveform:

```bash
gtkwave sim/atpg_fault.vcd
```

## Waveform

![ATPG Fault Detection Waveform](images/atpg_waveform.png)

## Conclusion

The simulation demonstrates how a stuck-at fault can be exposed by comparing a fault-free circuit with a faulty model. It introduces fundamental fault detection concepts used in DFT and ATPG.

This is a simplified educational demonstration; it does not implement scan chains or an industrial ATPG algorithm.
