🔗 AHB-to-APB Bridge Controller – Verilog HDL

This project implements an AMBA AHB-to-APB Bridge Controller in Verilog HDL. The bridge enables seamless communication between high-speed AHB masters and low-power APB peripherals. Designed as part of my VLSI/SoC design practice, the project focuses on RTL design, finite state machine (FSM) control, and protocol verification.

📌 Project Overview

The AHB-to-APB Bridge acts as an interface between the AMBA AHB (Advanced High-performance Bus) and the AMBA APB (Advanced Peripheral Bus).

The system is designed to:

Decode AHB addresses and map them to APB peripherals.

Generate appropriate control signals (PSEL, PENABLE, PWRITE, etc.).

Handle data transfers from AHB to APB with minimal latency.

Ensure protocol compliance through FSM-based sequencing.

📂 Project Structure
File	Description
ahb_controller.v	AHB interface logic: captures HADDR, HWRITE, and data signals.
apb_controller.v	FSM-based APB control logic (IDLE, SETUP, ACCESS).
bridge_top.v	Top-level wrapper connecting AHB and APB logic.
tb_bridge.v	Testbench simulating various AHB-to-APB transfer scenarios.
✅ Features Implemented

✅ FSM-based APB Controller (IDLE → SETUP → ACCESS)

✅ Address decoding for APB slave selection

✅ Read/Write transaction handling

✅ Zero-wait state transfer (for simple transactions)

✅ Error handling via default slave response

✅ Fully modular RTL (AHB, APB, Top, TB separated)

🧪 Simulation Output

The testbench (tb_bridge.v) verifies the following cases:

Write transfer – AHB → APB write transaction with data propagation.

Read transfer – AHB → APB read transaction with data return path.

Invalid address – Default slave response validation.

Sequential transfers – Back-to-back write/read handling.

Control signal validation – Timing correctness for PSEL, PENABLE, PWRITE.

👉 Sample waveform screenshots can be added here.

🔧 Tools Used

HDL: Verilog

Simulation: ModelSim / Vivado Simulator

Version Control: GitHub

🚀 How to Run

Open the project in ModelSim or Vivado.

Compile all RTL modules (ahb_controller.v, apb_controller.v, bridge_top.v) and tb_bridge.v.

Run the testbench using:

run -all


Observe console and waveform outputs for functional correctness.

🧠 Future Enhancements

Support wait states for slower APB peripherals

Add burst transfer support from AHB

Parameterized data/address width for scalability

Integration with real FPGA-based APB peripherals

👨‍💻 Author

Vignesh Bala Kumaran Devaraj
Graduate Student – MS in Computer Engineering
George Mason University – Fall 2024
