# 🧠 FPGA LIF Neuron Model – Leaky Integrate-and-Fire

This project implements a **Leaky Integrate-and-Fire (LIF) neuron** in Verilog HDL, deployed on FPGA.  
Developed as part of academic VLSI/Neuromorphic research, it demonstrates real-time biological neuron behavior using hardware-efficient design.  

---

## 📌 Project Overview

- **Goal**: Implement and validate a hardware prototype of the **LIF neuron model** on FPGA.  
- **Motivation**:  
  - Bio-inspired **event-driven computation**  
  - **Low-power edge computing** using spikes instead of continuous signals  
  - **FPGA advantage**: parallelism, reconfigurability, real-time execution  

---

## 🧮 LIF Neuron Model

- Equation:  
  \[
  \tau_m \frac{dV(t)}{dt} = -(V(t) - V_{rest}) + R_m \cdot I(t)
  \]
- Spike condition: when \( V(t) \geq V_{th} \), neuron fires and voltage resets.  
- Key variables:  
  - \(V(t)\): Membrane potential  
  - \(I(t)\): Input current  
  - \(V_{th}\): Threshold voltage  

---

## 📂 Project Structure

| File                | Description |
|----------------------|-------------|
| `lif_multi.v`       | Multi-neuron LIF core module |
| `lif_multi_tb.v`    | Testbench for neuron model simulation |
| `Lif_neuron_Top.v`  | Top-level integration for FPGA deployment |
| `uart_tx.v`         | UART transmitter for neuron state telemetry |
| `Cmod_S7.xdc`       | Xilinx constraints file for Cmod S7 FPGA board |

---

## ✅ Features

- Real-time **LIF neuron hardware implementation**  
- Supports **step, ramp, and pulse input currents**  
- Accurate **spike timing** with reset and leakage behavior  
- **Fixed-point arithmetic** (replaces floating point for FPGA efficiency)  
- UART-based **output logging**  
- LED **spike visualization** on FPGA  

---

## 🖥️ Simulation & Results

### Simulation Setup
- Tool: **Vivado Simulator**  
- Input types: step, ramp, constant currents  
- Outputs observed: membrane potential (`V`), spike signals  

### Observations
- Voltage rises until threshold, fires a spike, then resets.  
- Leakage visible when input current is insufficient.  
- Spike timing matches theoretical expectations.  

### Sample Waveform Behavior
- **Input current**: external stimulus applied  
- **Membrane voltage**: exponential integration + decay  
- **Spike output**: digital pulses when threshold reached  

---

## 🔧 FPGA Implementation

- **Board**: Xilinx Cmod S7 (XC7S25-1CSGA225C)  
- **Clock**: 100 MHz  
- **Output**: Spike connected to LED, UART stream for debugging  

### Resource Utilization
| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| LUTs     | 352  | 13,300    | 2.65% |
| FFs      | 198  | 13,900    | 1.42% |
| DSPs     | 2    | 90        | 2.22% |
| BRAMs    | 0    | 50        | 0% |

### Timing & Power
- Minimum clock period: **10.234 ns**  
- Max frequency: **97.7 MHz**  
- Power usage: **35.6 mW** (highly energy-efficient)  

---

## 🚀 How to Run

1. Open project in **Vivado**.  
2. Add RTL files: `lif_multi.v`, `uart_tx.v`, `Lif_neuron_Top.v`.  
3. Apply constraints from `Cmod_S7.xdc`.  
4. Run **Simulation** using `lif_multi_tb.v`.  
5. Synthesize, implement, and generate bitstream.  
6. Program FPGA:  
   - Observe **LED spike output**  
   - Use serial terminal (115200 baud) for **UART logs**  

---

## 🔮 Future Enhancements

- Multi-neuron architecture for spiking neural networks  
- Synaptic dynamics (STDP, Hebbian learning)  
- Event-based communication (AER protocol)  
- Edge AI deployment for IoT devices and robotics  

---

## 📌 Applications

- **Medical Devices**: brain-machine interfaces, prosthetic signal processing  
- **Edge Computing**: low-power neuromorphic inference for IoT  
- **Robotics**: adaptive biomimetic control systems  
- **Research**: testbed for neuromorphic algorithms and computational neuroscience  

---

## 👨‍💻 Authors

- Aijaz Ahmed Mohammed  
- Vignesh Bala Kumaran Devaraj  
- Akshitha Tunki  

---
