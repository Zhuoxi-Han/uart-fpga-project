# UART Communication System FPGA Project

Implement UART Transmitter and Receiver in Verilog on Terasic DE1-SoC using Quartus

# Project Goal

The goal of this project is to design and implement a complete UART communication system on the DE1-SoC FPGA board using Verilog.

This project aims to build a deep understanding of asynchronous serial communication by implementing UART transmitter and receiver modules from scratch.

# Key objectives:

* Understand UART protocol and frame structure
* Implement baud rate generation from 50 MHz system clock
* Design UART transmitter using FSM
* Design UART receiver with robust sampling logic
* Verify functionality using simulation and hardware testing
* Develop professional engineering documentation and debugging workflow

# Final Devliverable
* baud_gen.v
* uart_tx.v
* uart_rx.v
* top.v
* testbenches
* waveform screenshots
* README
* architecture
* debug logs
* lessons learned

# Concepts Covered
## Protocol
* UART frame
* start bit
* stop bit
* parity
* LSB first
* oversampling
* bit shift

## Timing
* baud rate
* bit period
* clock divider
* asynchronous communication

## RTL Design
* Finite State Machine
* counters
* shift registers
* edge detection

## Verification
* testbench
* waveform analysis
* timing validation

## Hardware
* pin assignment
* Quartus workflow
* FPGA debugging

# Milestone 0 -- Project Setup
## Tasks
* Setup Quartus project
* Setup GitHub repo
* Organize folder structure
* Write initial README

## Deliverable
* create a professional repository for this project

# Milestone 1 -- Learn UART fundamentals
## Tasks
* UART frame structure
* baud rate
* bit timing
* TX vs RX

## Deliverable
* document learnings in docs/learning_notes.md

# Milestone 2 -- Baud Generator
## Task
* generate the 115200 baud tick that UART needs from the 50MHz FPGA system clock.

## Deliverable
* docs/learning_notes.md
* docs/debug_log.md

# Milestone 3 UART Transmitter TX FSM
Design a complete finite state machine to realize serial transmission compliant to UART protocol.

The inputs are 
```verilog  
clk
rst
baud_tick
tx_start
data_in[7:0] 
```
and the outputs:
```verilog
tx
tx_busy
```

This module essentially want to send 1 start bit, 8 data bits and 1 stop bit when tx_start = 1.

## Learning Objective
- understand serial transimission and serial stream
- grasp UART frame transmission sequence
- FSM design
- shift register behavior/shift logic
- clock domain vs baud domain
- bit ordering

## Deliverable
- docs/learning_notes.md
- rt1/uart_tx.v
- tb/uart_tx_tb.v

# Milestone 4 -- UART Receiver
# Milestone 5 -- Hardware Integration
# Milestone 6 -- Polish Project
