# Digital Logic Design & SystemVerilog Portfolio 💻🔌

A comprehensive collection of SystemVerilog projects and digital logic designs completed during the **Digitaltechnik** (Digital Logic Design) course at **TU Darmstadt** (WiSe 25/26).

This repository demonstrates my progression from basic logic gates to complex hardware architectures like cryptographic networks and recursive module generation.

## 🚀 Projects Overview

| Directory | Topic | Description |
| :--- | :--- | :--- |
| **`HW-B-CombLogic`** | Combinational Logic | Implementation of a garage door controller with safety priorities and a 10-bit multi-code combination lock. |
| **`HW-C-Normalform`** | Normalform & LUTs | Normalform-driven development using Look-Up Tables (LUTs) and hierarchical submodule instantiation. |
| **`HW-D-SPNetwork`** | Cryptography (SPN) | Design of a 3-round Substitution-Permutation Network (SPN) featuring custom S-Boxes, P-Boxes, and a Key Schedule module. |
| **`HW-E-FSM`** | Finite State Machines | Implementation of Mealy FSMs for a reverse vending machine (Pfandautomat), including a master Handler FSM managing Sub-FSMs. |
| **`HW-F-CSA-Testbenches`** | Advanced SV & Testing | Recursive development of a Conditional Sum Adder (CSA) using `generate` blocks and self-checking testbenches. |

## 🛠️ Technologies & Skills
* **Hardware Description Language:** SystemVerilog
* **Core Concepts:** Combinational & Sequential Logic, Finite State Machines (Mealy), Submodule Instantiation, Recursive Hardware Generation.
* **Domain Expertise:** Digital System Architecture, Hardware-level Cryptography.
* **Simulation & Testing:** Automated self-checking testbenches.

## ⚙️ How to Run
Each project folder contains its own simulation scripts. [cite_start]To run a testbench, navigate to the specific folder and execute the provided shell or batch files:
* **Windows:** `./sim.bat <module_name>`
* **Linux/Mac:** `./sim.sh <module_name>`
