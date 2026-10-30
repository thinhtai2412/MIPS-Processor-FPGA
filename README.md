# MIPS Processor Implementation on FPGA

## Project Overview

This repository contains SystemVerilog modules developed as part of a collaborative Digital System Design course project.

The project focused on implementing a MIPS-inspired processor architecture using FPGA hardware. My primary responsibility was developing the processor control logic and supporting components.

## My Contributions

I worked on the following SystemVerilog modules:

| Module | Description |
|---|---|
| `ControlUnit.sv` | Control logic responsible for coordinating processor operations. |
| `ALU.sv` | Arithmetic Logic Unit for arithmetic and logical operations. |
| `FSM.sv` | Finite State Machine for controlling processor states and transitions. |
| `IR.sv` | Instruction Register that stores the current instruction. |
| `PC.sv` | Program Counter that tracks the processor's instruction address or position. |
| `ButtonSync.sv` | Button synchronization logic for handling FPGA button inputs. |

## Technologies Used

- SystemVerilog
- FPGA
- Digital Logic Design
- Computer Architecture
- Finite State Machines (FSM)

## Project Structure

```text
MIPS-Processor-FPGA/
├── ALU.sv
├── ButtonSync.sv
├── ControlUnit.sv
├── FSM.sv
├── IR.sv
├── PC.sv
└── README.md
```

## Project Scope

This repository highlights the modules I contributed to a collaborative MIPS-inspired processor project. It does not contain the complete processor implementation.

## Academic Context

Developed as part of Digital System Design coursework at the University of Washington.

## FPGA Hardware Demonstration

The project was implemented and demonstrated on an Intel/Altera DE2-115 FPGA development board.

The demonstration video shows the hardware running with numerical outputs displayed on the board's seven-segment displays.

The hardware test and video recording were performed by my project teammate.

[Watch FPGA Demonstration](FPGA_Demo.mp4)
