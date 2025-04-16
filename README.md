# High-Count-Rate Single-Photon LiDAR with Free-Running InGaAs/InP SPAD
By Linjie Lyu, Duan Li*

## Technical Overview
This implementation demonstrates a single-photon detection LiDAR system where higher count rates enable faster information acquisition and detection speeds. Compared with the traditional detection speed of tens of milliseconds, the system can achieve a detection speed of 0.2 ms per pixel:

1. **Enhanced photon flux**: Echo signal flux maintained at 0.5-3 photons per pulse cycle
2. **Increased repetition rate**: Laser operation at 3.125 MHz repetition frequency

## Key Technical Challenges Addressed
1. **Modeling gap**: Absence of mathematical framework relating photon count rate to signal flux and repetition frequency
2. **Waveform distortion**: Nonlinear errors induced by high-repetition-frequency and high-flux operation
3. **Range ambiguity**: The maximum unambiguous challenges in high-repetition-frequency ranging

## Core Innovations
- Developed count rate mathematical model incorporating signal flux and repetition frequency
- Implemented waveform correction algorithm under high-repetition-frequency and high-fllux Time-Correlated Single-Photon Counting (TCSPC).
- Demonstrated dual-frequency laser ranging solution for range ambiguity

## Repository Structure
| Directory | Content Description |
|-----------|---------------------|
| `/data` | Simulation-collected datasets |
| `/monte_carlo_gen` | Monte Carlo data generation scripts |
| `/count_rate_model` | Count rate model validation |
| `/correct_simulation_ver` | Waveform correction algorithms |
| `/gray_scale_plate` | Gray scale plate measurement and comparison experiments |
| `/40_120m_building_mapping` | Building mapping scenarios (40-120m range) |

## Implementation Guide

### Data Preparation
1. Clone repository and extract all files
2. Download the data files:
   - [gray_scale_plate.zip](https://www.dropbox.com/scl/fi/9r8c8bx7y2dgdhrxcwb82/gray_scale_plate.zip?rlkey=udb53t5lodbwe1oqiammjh94q&st=gjr8014b&dl=0)
   - [20250122-1231-two-repetition-rate.zip](https://www.dropbox.com/scl/fi/gm4hiyc3k7d2v8xzux02p/20250122-1231-two-repetition-rate.zip?rlkey=1qi8r0chbh2gkr6n9oepg23h7&st=p46c7isp&dl=0)
   
   Then place the datasets in their respective folders:
   - `gray_scale_plate.zip` → `./gray_scale_plate/`
   - `20250122-1231-two-repetition-rate.zip` → `./40_120m_building_mapping/`
4. Extract all `.zip` contents in `/data`, `/gray_scale_plate` and `/40_120m_building_mapping`.

### Execution
1. Add full directory to MATLAB path (verified on 2018b)
2. Run processing scripts:
- change the code in Line 52 for noise-free condition (0 kHz)，`filename = [currentFolder,'\data\count_rate_ver\fr_',num2str(i),...
           'fn_0k_Ns_',num2str(Ns_ground_truth(j)),'.mat'];`

- change the code in Line 52 for noise-free condition (200 kHz)，`filename = [currentFolder,'\data\count_rate_ver\fr_',num2str(i),...
           'fn_200k_Ns_',num2str(Ns_ground_truth(j)),'.mat'];`

![图片](https://github.com/user-attachments/assets/6262811b-58a2-4bea-a293-4d1044c936a9)

-Excute 'correct_simulation_ver\simulation_data_process_fig6.m'

![图片](https://github.com/user-attachments/assets/970d76a4-35c8-4a02-af53-e56f196faa8e)


- excute 'gray_scale_plate\read_data_20240101_2_3125_fig7.m'

![图片](https://github.com/user-attachments/assets/599b89dc-4aac-4d28-82b0-2dd395d9acdb)

- excute  '40_120m_building_mapping\read_data_house_2_frequency.m'

![图片](https://github.com/user-attachments/assets/ac468cc0-7f19-4429-a95f-cfd5efc07546)
![图片](https://github.com/user-attachments/assets/0d4c9918-ba9c-40df-adb0-a2ac9b0f1d9f)

![图片](https://github.com/user-attachments/assets/8cf1130d-aec8-4d0f-a338-3e2f098cf97e)
![图片](https://github.com/user-attachments/assets/13756c2e-8fd9-463e-843f-7ccb781adcc9)


