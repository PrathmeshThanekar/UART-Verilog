# UART Communication in Verilog

A UART (Universal Asynchronous Receiver-Transmitter) communication system designed and implemented using Verilog HDL. The project includes a UART transmitter, receiver, top-level integration, and simulation verification using Xilinx Vivado.

## Project Overview

This project implements serial communication between a UART transmitter and receiver.

The transmitter converts 8-bit parallel data into a serial UART data stream, while the receiver samples the incoming serial signal and reconstructs the original 8-bit data.

### UART Configuration

| Parameter | Value |
|---|---:|
| FPGA Clock Frequency | 100 MHz |
| Baud Rate | 9600 |
| Data Bits | 8 |
| Start Bits | 1 |
| Stop Bits | 1 |
| Parity | None |
| Data Order | LSB First |

## UART Frame Format

Each transmitted byte consists of 10 bits:

```text
        Start      Data Bits                         Stop
          ↓       ↓                                  ↓
         ┌───┬───────┬───────────────────────────────┐
         │ 0 │ D0-D7 │               1               │
         └───┴───────┴───────────────────────────────┘
