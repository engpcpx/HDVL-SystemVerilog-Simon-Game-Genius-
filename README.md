# PBL1 - Simon Game (Genius) – SystemVerilog Implementation

SystemVerilog-based implementation of the classic **Simon (Genius)** memory game, designed to run on a RISC-V compatible hardware platform. This project includes a complete RTL design, modular architecture, and self-checking testbenches for functional verification.

---

## Project Overview

- **Language**: SystemVerilog (IEEE 1800-2017)
- **Design Style**: RTL (Register Transfer Level)
- **Target Architecture**: RISC-V (RV32I subset)
- **Verification**: Self-checking Testbenches + Simulation
- **Coding Style**: Modular and interface-oriented (using `interface` and `modport`)
- **Tool Compatibility**: Icarus Verilog, ModelSim, etc.

---

## Features

- Random sequence generation
- Playback of patterns using LEDs
- User input via push buttons
- FSM-based control logic
- 7-segment display output
- Modular code using SystemVerilog interfaces

---

# Resources
    This application make use interface bus structure to transfer data betueen modules.
    
---

## Project Structure

```text
simon-game/
├── chip_module.sv             # Top-level chip module (instantiates all components)
├── control_if.sv              # User control interface (buttons, status, start/reset)
├── settings_if.sv             # Configuration interface (clock, reset, level)
├── fsm_module.sv              # Main FSM that manages game flow
├── generator_module.sv        # Sequence generation logic
├── idle_module.sv             # Handles idle state behavior
├── display_7seg_module.sv     # 7-segment display control module
├── sim/                       # Testbench directory
│   └── simon_tb.sv            # Functional testbench (self-checking)
└── README.md                  # This file
