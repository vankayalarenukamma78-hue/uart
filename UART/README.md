# UART (Universal Asynchronous Receiver/Transmitter)

## Description

UART is a serial communication protocol used to transmit and receive data between two devices without using a common clock.

## Features

* 8-bit data transmission
* Start bit and stop bit
* Configurable clock and baud rate
* Serial data transmission and reception

## Files

* `uart.v` – UART transmitter and receiver Verilog code
* `uart_tb.v` – Testbench for simulation
* `expected_output.txt` – Expected simulation output

## Working

UART sends data serially, one bit at a time. Each transmission consists of:

* 1 Start bit
* 8 Data bits
* 1 Stop bit

## Simulation

Compile and simulate using a Verilog simulator such as Icarus Verilog or ModelSim.

### Example using Icarus Verilog

```bash
iverilog -o uart_sim uart.v uart_tb.v
vvp uart_sim
```

## Expected Result

The transmitted 8-bit data is received correctly, and the received data should match the transmitted data.
