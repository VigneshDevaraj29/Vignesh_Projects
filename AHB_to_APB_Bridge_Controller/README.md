# 🔗 AHB to APB Bridge Controller – Verilog HDL

This project implements an **AHB-to-APB Bridge Controller** in Verilog HDL, developed as part my internship at Maven Silicon on **VLSI ASIC Design**.  
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

---

## 🛠️ Tools Used

- **Simulation:** ModelSim SE 
- **Simulation:** Quartus Prime
- **HDL:** Verilog  

---

## 🚀 How to Run

1. Open the project in **ModelSim**.  
2. Compile all Verilog modules and `tb_ahb_to_apb.v`.  
3. Run the testbench using `run -all`.  
4. Observe **console messages** and **waveform outputs** for verification.  

---

## 🔮 Future Enhancements

- Extend support for **pipelined AHB transfers**  
- Add **configurable number of APB peripherals**  
- Implement **synthesis on FPGA (Xilinx/Intel)**  
- Include **UVM/SystemVerilog testbench** for advanced verification  

---

## 👨‍💻 Author

**Vignesh Bala Kumaran Devaraj**  
Graduate Student – MS in Computer Engineering  
George Mason University  

---
