# 🔗 AHB to APB Bridge Controller – Verilog HDL

This project implements an **AHB-to-APB Bridge Controller** in Verilog HDL, developed as part of the **ECE course on Digital System Design**.  
The bridge ensures smooth communication between the high-performance **AMBA AHB bus** and the low-power **AMBA APB bus**, enabling efficient peripheral interfacing.  
All modules are fully simulated and verified using **ModelSim**.

---

## 📌 Project Overview

The AHB-to-APB Bridge is designed to:

- Interface an **AHB master** (high-speed bus) with multiple **APB peripherals** (low-power bus).
- Handle **address decoding**, **state transitions**, and **data transfer** across buses.
- Support **read/write operations** with handshake signals (`PREADY`, `PENABLE`, etc.).
- Implement a **finite state machine (FSM)** to manage protocol timing.

---

## 📂 Project Structure

| Module File              | Description |
|---------------------------|-------------|
| `ahb_to_apb_bridge.v`    | Top-level bridge module integrating AHB-to-APB transactions. |
| `ahb_slave_interface.v`  | Handles AHB signals and generates control signals for the bridge. |
| `apb_master_interface.v` | Controls APB signals and manages peripheral selection/enable. |
| `fsm_controller.v`       | Implements FSM for read/write sequencing. |
| `tb_ahb_to_apb.v`        | Testbench simulating various AHB transactions to APB peripherals. |

---

## ✅ Features Implemented

- AHB-to-APB protocol conversion
- Address decoding for multiple APB peripherals
- FSM-based control for read/write transfers
- Handshake support with `PREADY`, `PENABLE`, `PSLVERR`
- Fully functional **Verilog testbench**
- Simulation and waveform verification in **ModelSim**

---

## 🖥️ Simulation Output

The testbench (`tb_ahb_to_apb.v`) validates the following scenarios:

1. **Write transaction**: AHB master writes data to APB peripheral  
2. **Read transaction**: AHB master reads data from APB peripheral  
3. **Address decode check**: Ensures correct peripheral selection  
4. **Wait state handling** with `PREADY` low  
5. **Error response** with `PSLVERR`  

### Sample Simulation Log (Console Output)

