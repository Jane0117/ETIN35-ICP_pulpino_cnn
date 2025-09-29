# Project Scripts & Modified RTL

A compact collection of EDA automation scripts and modified RTL used for coursework/labs.  
**Grade3 (G3)** = baseline level; **Grade5 (G5)** = advanced level with CNN peripherial.

## 📂 Directory Structure

| Folder           | Purpose / Tools                               | Notes |
|------------------|-----------------------------------------------|-------|
| `PNR`            | **Place & Route** Tcl scripts — *G3*          | Basic Innovus/ICC2 flow (floorplan → place → CTS → route). |
| `PNR_CNN`        | **Place & Route** Tcl scripts — *G5*          | CNN-oriented, more tunables |
| `Primetime`      | **PrimeTime** power analysis scripts           | Power Analyse Scripts |
| `pulpino`        | **Modified PULPino** sources                   | Only the changed files: `rtl/`, `tb/`, and partial `vsim/`. |
| `synthesis_1`    | **Synthesis** Tcl scripts — *G3*               | Baseline Genus setup, clocks/constraints. |
| `synthesis_cnn`  | **Synthesis** Tcl scripts — *G5*               | CNN-focused synthesis with additional switches and parsing. |

> 🗣️ **Script language:** Tcl (primary). 

## ⚡ Quick Start

> Replace tool invocations/paths to match your environment. Example only.

```tcl
# --- Synthesis (Genus or Design Compiler) ---
# Baseline
source ./synthesis_1/scripts/synt.tcl
# CNN variant
source ./synthesis_cnn/scripts/synt.tcl

# --- Place & Route (Innovus or ICC2) ---
# Baseline
source ./PNR/tcl_pnr/run.tcl
# CNN variant
source ./PNR_CNN/tcl_pnr/0_run.tcl

# --- PrimeTime Power ---
source ./Primetime/set_up.tcl
