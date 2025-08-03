# 🔐 Smart Home Automation System (SHA) - Verilog HDL

This is a Verilog-based **Smart Home Automation** project developed as part of the *ECE 516 – Mobile Systems and Applications* course at **George Mason University**. The system provides modular security, comfort control, and password-based access features, fully verified via simulation in ModelSim.

---

## 📌 Project Overview

The SHA system is designed to:
- Secure home access via password authentication.
- Trigger alarms for multiple security threats.
- Control comfort parameters such as lighting, heating, and air conditioning.
- Allow users to change passwords and handle incorrect login attempts with lockout functionality.

---

## 📂 Project Structure

| Module File            | Description |
|------------------------|-------------|
| `SHA_Top_Module.v`     | Top-level wrapper integrating all submodules. |
| `SensorSynchronizer.v` | Handles asynchronous sensor signal synchronization. |
| `KeypadScanner.v`      | Simulates a keypad to input passwords. |
| `PasswordInput.v`      | Manages password entry and storage. |
| `SecuritySystem.v`     | Controls alarms (door, window, fire, garage) and buzzer. |
| `ComfortControl.v`     | Handles lighting (bright, dim, normal), AC, and heater. |
| `Tb_SHA.v`             | Complete Verilog testbench simulating various real-life scenarios. |

---

## ✅ Features Implemented

- ✅ Multi-attempt password authentication
- ✅ Lockout after 3 wrong password attempts
- ✅ Password change functionality
- ✅ Alarms for security breaches (fire, door, window, garage)
- ✅ Smart comfort control (heater, AC, lights)
- ✅ Synchronized sensor input handling
- ✅ Fully simulated using ModelSim

---

## 🧪 Simulation Output

The testbench (`Tb_SHA.v`) simulates the following test cases:

1. **Wrong password attempts** – Lockout after 3 wrong entries  
2. **Attempting input during lockout**  
3. **Correct password after lockout duration**  
4. **All alarms triggered**  
5. **Comfort control scenario (Heater + Dim Light → AC + Bright Light)**  
6. **Password change process**  
7. **Login with new password**

**Sample Simulation Output:**
<img width="1420" height="625" alt="image" src="https://github.com/user-attachments/assets/606374f4-bf95-4041-95ef-2d93492247e4" />

---

## 🔧 Tools Used

- **Simulation:** ModelSim SE
- **HDL:** Verilog
- *(Optional: For FPGA Synthesis → Xilinx Vivado / Quartus Prime Lite)*

---

## 🚀 How to Run

1. Open the project in **ModelSim**.
2. Compile all the Verilog modules and `Tb_SHA.v`.
3. Run the testbench using:
run -all
4. Observe console and waveform outputs for functional verification.

---

## 🧠 Future Enhancements

- Integrate real-time sensors via FPGA GPIO
- Extend password system to biometric/RFID
- Include a GUI-based interface for control
- IoT-based remote monitoring and control

---

## 👨‍💻 Author

**Vignesh Bala Kumaran Devaraj**  
Graduate Student – MS in Computer Engineering  
George Mason University  
Fall 2024 

---

