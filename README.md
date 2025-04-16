# High-counting-rate-single-photon-LiDAR-with-free-running-InGaAs-InP-SPAD
by linjie lyu, duan li*

**Single-Photon Detection LiDAR**: A higher count rate in single-photon detection LiDAR leads to faster information acquisition and detection speed. The paper employs two methods to improve the system count rate:  
1. Increasing the echo photon signal flux, with the signal flux per pulse cycle controlled within the range of [0.5, 3] photons.  
2. Increasing the laser repetition frequency, achieving a repetition rate of 3.125 MHz.  

**Current Technical Challenges**:  
1. Lack of a mathematical model describing the relationship between photon count rate, signal flux, and laser repetition frequency.  
2. Operating the LiDAR system under high repetition frequency and high flux conditions can cause waveform distortion, leading to nonlinear errors.  
3. High repetition frequency laser ranging introduces range ambiguity issues.  

**Main Contributions of the Paper**:   
- A mathematical model of counting rate related to signal flux and laser refrequency.  
- A waveform correction algorithm for high-repetition-frequency and high-fllux Time-Correlated Single-Photon Counting (TCSPC).  
- A method for solving range ambiguity by dual frequency laser ranging.  

**Data and Code File Annotations**:  
- The collected data by simulation are stored in the `/data` folder.  
- Monte Carlo data generation code is located in `/monte_carlo_gen`.  
- Count rate model validation code is in `/count_rate_model`.  
- Correction algorithm simulation and verification are in `/correct_simulation_ver`.  
- Gray-scale plate experiment code and data are in `/gray_scale_plate`.  
- Building mapping scenario (40–120 m) code and data are in `/40_120m_building_mapping`.  

**Usage Steps**
1. Download the code repository files and extract them;
2. Download the data files:  
- Place the 'gray_scale_plate' data file in the `./gray_scale_plate` folder.  
- Place the '20250122-1231-two-repetition-rate' data file in the `./40_120m_building_mapping` folder.  
- Extract both archives after placement;
3. Extract the data files inside the `/data` folder;
4. Add the entire directory to the MATLAB path (tested on version 2018b);
5. Execute the scripts.
