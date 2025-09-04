# 🔗 AHB to APB Bridge Controller – Verilog HDL

This project implements an **AHB-to-APB Bridge Controller** in Verilog HDL, developed as part of my **internship at Maven Silicon** on **VLSI ASIC Design**.  
The bridge enables seamless communication between the high-performance **AMBA AHB bus** and the low-power **AMBA APB bus**, allowing efficient peripheral interfacing.  
All modules are fully simulated and verified using **ModelSim**, and synthesis was performed for RTL verification.

---

## 📌 Project Overview

The AHB-to-APB Bridge is designed to:

- Interface an **AHB master** (high-speed bus) with multiple **APB peripherals** (low-power bus).
- Handle **address decoding**, **state transitions**, and **data transfer** across buses.
- Support **single read/write** and **burst write transactions**.
- Implement a **finite state machine (FSM)** to manage protocol timing and sequencing.
- Provide a **modular architecture** for easier debugging and reuse in SoC integration.

---

## 📂 Project Structure

| Module File              | Description |
|---------------------------|-------------|
| `AHB_master_Interface.v` | Generates AHB protocol transactions (single, read, burst) for testing. |
| `AHB_Slave.v`  | Receives AHB signals, pipelines data, and produces APB control signals. |
| `APB_Controller.v`       | Converts AHB-side info into APB signals (`Pselx`, `Penable`, `Pwrite`, `Paddr`, `Pwdata`). |
| `APB_Interface.v`        | Simulates an APB peripheral, responding to read/write transactions. |
| `Bridge_Top.v`           | Top-level interconnection between AHB Slave and APB Controller. |
| `tb_ahb_to_apb.v`        | Testbench driving traffic and verifying functionality. |

---

## ✅ Features Implemented

- AHB-to-APB protocol conversion  
- **Single and burst transfer support**  
- FSM-based control for read/write transfers  
- Address decoding for multiple APB peripherals  
- Handshake support (`PREADY`, `PENABLE`, `PSLVERR`)  
- Fully functional **Verilog testbench**  
- **Simulation waveforms** for all blocks  
- **Synthesis and RTL Viewer verification**  

---

## 🖥️ Simulation Output

The testbench validates:

1. **Single write transaction** – AHB master writes data to APB peripheral  
2. **Single read transaction** – AHB master reads data from APB peripheral  
3. **Burst transactions** – multi-cycle transfers validated on waveform  
4. **Address decode check** – ensures correct peripheral selection  
5. **Wait state handling** with `PREADY` low  
6. **Error response** with `PSLVERR`  

### Sample Simulation Log

<img width="1471" height="1028" alt="image" src="https://github.com/user-attachments/assets/6fb7d7a6-9241-4aff-8d07-b6ce269c329f" />

---

## 🛠️ Tools Used

- **Simulation:** ModelSim SE  
- **Synthesis:** Quatus Prime  
- **HDL:** Verilog  

---

## 🚀 How to Run

1. Open the project in **ModelSim**.  
2. Compile all Verilog modules and `tb_ahb_to_apb.v`.  
3. Run the testbench using `run -all`.  
4. Observe **console messages**, **waveforms**, and **synthesis RTL diagrams** for verification.  

---

## 🔮 Future Enhancements

- Extend support for **pipelined AHB transfers**  
- Add **configurable number of APB peripherals**  
- Implement **synthesis on FPGA (Xilinx/Intel)**  
- Include **UVM/SystemVerilog testbench** for advanced verification  

---

## 📌 Conclusion

This project successfully implements an AHB to APB bridge that:  
- Handles **single and burst transfers**  
- Provides a **modular design** with dedicated roles for each block  
- Operates fully according to **AMBA specifications**  
- Can be integrated into larger **SoC designs**, with the APB Interface easily replaced by actual peripherals  

---

## 👨‍💻 Author

**Vignesh Bala Kumaran Devaraj**  
Graduate Student – MS in Computer Engineering  
George Mason University  

---
