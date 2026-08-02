# Design and Verification of Asynchronous FIFO

## Overview

This project implements the RTL Design and SystemVerilog Verification of an **Asynchronous FIFO (First-In First-Out)** memory. The FIFO safely transfers data between two independent clock domains using **Gray-code pointers** and **two-stage synchronizers**, preventing metastability during clock domain crossing (CDC).

A self-checking verification environment has been developed using SystemVerilog to validate FIFO functionality under multiple operating scenarios.

---

## Project Features

- RTL implementation of Asynchronous FIFO
- Independent Read and Write Clock Domains
- Gray Code Pointer Generation
- Two-Stage Synchronizers for CDC
- Full Flag Generation
- Empty Flag Generation
- Pointer Wrap-Around Handling
- Parameterized Design
- Modular RTL Architecture
- Self-Checking Verification Environment
- Directed and Random Testcases

---

## Directory Structure

```
Design-Verification-of-Asynchronous-FIFO
│
├── rtl
│   ├── design.sv
│   ├── synchroniser.v
│   ├── wptr_full.v
│   ├── rptr_empty.v
│   └── top_asynch_fifo.sv
│
├── tb
│   ├── fifo_transaction.sv
│   ├── generator.sv
│   ├── fifo_driver.sv
│   ├── fifo_monitor.sv
│   ├── fifo_scoreboard.sv
│   ├── fifo_environment.sv
│   └── testbench.sv
│
├── testcases
│   ├── write_only.sv
│   ├── read_only.sv
│   ├── write_read.sv
│   ├── write_single.sv
│   ├── write_full.sv
│   ├── read_empty.sv
│   ├── pointer_wrap_around.sv
│   ├── fifo_reset.sv
│   ├── test_random.sv
│   ├── alternate_write_read.sv
│   └── write_faster_than_read.sv
│
└── README.md
```

---

## RTL Architecture

The RTL implementation consists of the following modules:

### design.sv

Top-level module integrating all FIFO components.

### synchroniser.v

Implements a two-stage synchronizer to safely transfer Gray-coded pointers between asynchronous clock domains.

### wptr_full.v

Responsible for:

- Write Pointer Generation
- Binary-to-Gray Conversion
- Full Flag Detection

### rptr_empty.v

Responsible for:

- Read Pointer Generation
- Binary-to-Gray Conversion
- Empty Flag Detection

### top_asynch_fifo.sv

Implements FIFO Memory Storage and connects all RTL blocks.

---

## Verification Environment

The verification environment is completely modular.

### Transaction

Stores all transaction information.

### Generator

Creates directed and randomized stimulus.

### Driver

Drives transactions onto the DUT interface.

### Monitor

Samples DUT signals and converts them into transactions.

### Scoreboard

Compares expected and actual results to verify correctness.

### Environment

Connects all verification components together.

---

## Verification Flow

```
Generator
    │
    ▼
 Driver
    │
    ▼
 Asynchronous FIFO DUT
    │
    ▼
 Monitor
    │
    ▼
 Scoreboard
```

---

## Testcases Implemented

| Testcase | Description |
|----------|-------------|
| Write Only | Continuous write operations |
| Read Only | Continuous read operations |
| Write Read | Simultaneous read/write |
| Write Single | Single write transaction |
| Write Full | Verify FIFO full condition |
| Read Empty | Verify FIFO empty condition |
| Pointer Wrap Around | Pointer rollover verification |
| FIFO Reset | Reset functionality verification |
| Random Test | Randomized transactions |
| Alternate Write Read | Alternate write/read sequence |
| Write Faster Than Read | Different clock rate verification |

---

## Key Concepts Demonstrated

- Asynchronous FIFO Design
- Clock Domain Crossing (CDC)
- Gray Code Counters
- Binary to Gray Conversion
- Gray to Binary Synchronization
- Full and Empty Detection
- Pointer Wrap Around
- Two-Flip-Flop Synchronizer
- RTL Design
- Functional Verification
- Self-Checking Testbench
- Modular Verification Environment

---

## Tools Used

- SystemVerilog
- Verilog
- EDA Playground

---

## Applications

Asynchronous FIFOs are widely used in:

- Network Routers
- PCI Express
- USB Controllers
- Ethernet MAC
- DDR Memory Controllers
- DMA Engines
- Video Processing
- High-Speed Data Acquisition Systems
- SoC Designs
- FPGA and ASIC Designs

---

## Future Improvements

- Functional Coverage
- Assertions (SVA)
- Constrained Random Verification
- Code Coverage Analysis
- UVM-Based Verification Environment
- Regression Automation

---

## Author

**Tirth Bavaliya**

Electronics and Communication Engineering

RTL Design | ASIC Design | FPGA Design | Design Verification | VLSI

---

## License

This project is developed for educational purposes and interview preparation.
