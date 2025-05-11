# HDVL - SystemVerilog - Simon-Game
SystemVerilog-based implementation of the classic Simon (Genius) memory game, designed to run on a RISC-V compatible hardware platform. Includes RTL design, testbenches, and simulation instructions.

# Simon Game (Genius) on RISC-V – SystemVerilog Implementation

This repository contains a SystemVerilog-based RTL design of the classic **Simon (Genius)** memory game, adapted to run on a custom **RISC-V** hardware platform. The game challenges users to replicate increasingly complex sequences of lights and sounds, testing memory and reaction.

## 🧠 Project Overview

- **Language**: SystemVerilog (IEEE 1800-2017)
- **Target Architecture**: RISC-V (RV32I subset)
- **Design Style**: RTL (Register Transfer Level)
- **Testing**: Self-checking Testbenches + Simulation

The design includes all essential logic to implement the Simon game mechanics:
- Random sequence generation
- Pattern playback using LEDs and audio tones
- User input matching via push buttons
- State machine to control game flow

## 📁 Repository Structure
