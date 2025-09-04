# 🧠 FPGA LIF Neuron Model – Leaky Integrate-and-Fire

This project implements a **Leaky Integrate-and-Fire (LIF) neuron** in Verilog HDL, deployed on FPGA.  
I completed this project as part of my **ECE 556 course (Spring 2025 semester)**.  
Developed within the context of **academic VLSI/Neuromorphic research**, it demonstrates real-time biological neuron behavior using hardware-efficient design.  
The project was simulated in **Xilinx Vivado Simulator** and deployed on **Xilinx Cmod S7 (XC7S25-1CSGA225C)** FPGA with real-time spike visualization on LEDs and UART logging.

---

## 📌 Project Overview

- **Goal**: Implement and validate a hardware prototype of the **LIF neuron model** on FPGA.  

The FPGA LIF Neuron is designed to:

- Model **biological spiking behavior** using a discrete-time LIF equation.  
- Support **step, ramp, and pulse current inputs** to stimulate the neuron.  
- Perform hardware-efficient **fixed-point arithmetic** (instead of floating-point).  
- Provide real-time **LED spike output** and **UART telemetry** for monitoring.  
- Demonstrate scalability toward **neuromorphic computing architectures**.  

---

## 🧮 LIF Neuron Model

- Equation:  
  τm dV(t)/dt = -(V(t) - Vrest) + Rm·I(t)
<img width="630" height="76" alt="image" src="https://github.com/user-attachments/assets/a0c98014-7c5b-477a-9663-9fc184e1a3fd" />
- Spike condition: 
When V(t) ≥ Vth, neuron fires
<img width="508" height="76" alt="image" src="https://github.com/user-attachments/assets/ba2df963-926b-4d31-80d4-fb9b72e060b2" />
- Key variables:  
  - (V(t)): Membrane potential  
  - (I(t)): Input current  
  - (V{th}): Threshold voltage  

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

- Hardware-based **Leaky Integrate-and-Fire Neuron**  
- **Threshold-based spiking** with automatic reset  
- **Exponential leakage** when current is insufficient  
- Real-time **LED spike indication** on FPGA  
- **UART telemetry** for monitoring neuron voltage and spikes  
- Testbench validation with step, ramp, and pulse current patterns  
- Fully simulated and synthesized using **Vivado**  

---


### Simulation Setup
- Tool: **Xilinx Vivado Simulator**  
- Input types: step, ramp, constant currents  
- Outputs observed: membrane potential (`V`), spike signals  

## 🖥️ Simulation Output

The testbench (`lif_multi_tb.v`) validates the following test cases:

1. Step input current → periodic spike firing  
2. Ramp input current → spike frequency increase  
3. Sub-threshold input → no spikes generated  
4. Pulse input current → burst-like firing  
5. Reset verification after spike  

---

## 🔧 FPGA Implementation
![Cmod_S7](https://github.com/user-attachments/assets/a6871913-5378-4050-b530-904d8812f0df)
- **Board**: Xilinx Cmod S7 (XC7S25-1CSGA225C)  
- **Clock**: 100 MHz  
- **Output**: Spike connected to LED, UART stream for debugging  

## 📡 Hardware UART Output

When programmed on FPGA (Cmod S7), the **spike events** are transmitted via UART (115200 baud) and observed using **PuTTY**.  
Each threshold-crossing generates a message, followed by reset confirmation.

### Sample UART Output
SPIKE! - TH1
SPIKE! - TH2
SPIKE! - TH3
SPIKE! - TH4
resets to 0

📷 Example PuTTY Log:  

![PuTTy Terminal_output](https://github.com/user-attachments/assets/9d07fd19-f6a8-451a-873a-d9e72c289245)

- **TH1, TH2, TH3, TH4** → Correspond to spike events from multiple neuron thresholds.  
- **resets to 0** → Confirms membrane potential reset after spike.  
- This validates **real-time spiking** and threshold-based behavior on actual FPGA hardware.  
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

1. Open project in **Xilinz Vivado**.  
2. Add RTL files: `lif_multi.v`, `uart_tx.v`, `Lif_neuron_Top.v`.  
3. Apply constraints from `Cmod_S7.xdc`.  
4. Run **Simulation** using `lif_multi_tb.v`.  
5. Synthesize, implement, and generate bitstream.  
6. Program FPGA:  
   - Observe **LED spike output**  
   - Use serial terminal (115200 baud) for **UART logs**  
![Xilinx Vovado Snippet](https://github.com/user-attachments/assets/c813ffc1-9655-42e2-b1f5-84bc2a1ea62d)

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

- Vignesh Bala Kumaran Devaraj  
 

---
