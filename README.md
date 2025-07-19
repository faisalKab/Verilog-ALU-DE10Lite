# Verilog ALU – DE10-Lite

Author: Faisal Kabir  
Course: EECS3201 – Digital Logic Design (Summer 2023)  

## 🔧 Summary

This ALU was implemented using **pure gate-level logic in Verilog**.  
No behavioral code, no `if` statements, no LUTs — only raw logic gates and multiplexers.
I went above and beyond by hardcoding everything using logic expressions instead of software-style conditionals.

Designed for the Altera **DE10-Lite FPGA** board.

## 🧠 Features

- 4-bit opcode: OR, AND, XOR, ADD, SUB
- 3-bit operands: A and B
- Fully custom:
  - Full adder
  - Overflow detection
  - Custom MUX for op selection
- Result displayed on LED array
- Displays `E` on 7-segment display for invalid opcodes

## 📁 File Structure

- `Lab4.sv`: Verilog source file
- `.qsf`, `.qpf`: Quartus project files
- `simulation/`, `db/`: Auto-generated folders
- `LAB4.pdf`: Assignment spec
- `214422687 - LAB4 - EECS3201.pdf`: Report + logic breakdown

## 🚀 Demo

Instruction is 10-bit: `opcode[3:0]`, `a[2:0]`, `b[2:0]`  
Output is on LEDs and 7-segment (error)

