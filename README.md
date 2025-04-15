# High-counting-rate-single-photon-LiDAR-with-free-running-InGaAs-InP-SPAD

**Single-Photon Detection LiDAR**: A higher count rate in single-photon detection LiDAR leads to faster information acquisition and detection speed. The paper employs two methods to improve the system count rate:  
1. Increasing the echo photon signal flux, with the signal flux per pulse cycle controlled within the range of [0.5, 3] photons.  
2. Increasing the laser repetition frequency, achieving a repetition rate of 3.125 MHz.  

**Current Technical Challenges**:  
1. Lack of a mathematical model describing the relationship between photon count rate, signal flux, and laser repetition frequency.  
2. Operating the LiDAR system under high repetition frequency and high flux conditions can cause waveform distortion, leading to nonlinear errors.  
3. High repetition frequency introduces range ambiguity issues.  

**Main Contributions of the Paper**:   
- A mathematical model for count rate.  
- A waveform correction algorithm for high-repetition-frequency and high-fllux Time-Correlated Single-Photon Counting (TCSPC).  
- A method to resolve range ambiguity.  

**Data and Code File Annotations**:  
- The collected data by Lidar system and simulation are stored in the `/data` folder.  
- Monte Carlo data generation code is located in `/monte_carlo_gen`.  
- Count rate model validation code is in `/count_rate_model`.  
- Correction algorithm simulation and verification are in `/correct_simulation_ver`.  
- Gray-scale plate experiment code is in `/gray_scale_plate`.  
- Building mapping scenario (40–120 m) code is in `/40_120m_building_mapping`.  


