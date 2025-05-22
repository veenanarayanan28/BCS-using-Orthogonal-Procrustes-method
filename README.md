**Signal Reconstruction from Blind Compressive Measurements using Procrustes Method**

This repository provides a MATLAB implementation of a technique to reconstruct speech signals from their blind compressed measurements, where the sparsifying basis is unknown. 
The method employs the Orthogonal Procrustes method to estimate the basis and refines the reconstructed signal using ℓ₁-trend filtering.

🧠 **Method Overview**

Blind compressed sensing involves recovering a signal from compressed measurements when the sparsifying transform is unknown. 

This implementation focuses on:
-Estimating the sparse representing coefficients using **Basis pursuit algorithm**.
-Estimating the unknown sparsifying basis using the **Orthogonal Procrustes method**.
-Estimating the Signal by applying **ℓ₁-trend filtering**

🗂️ **File Structure**

**Main code and input file:**

├── main_BCS_PM_speech.m         # Main script for signal reconstruction
├── speech_A_Y_m32_rev4.mat      # Input speech data

**Functions:**

├── updating_C.m                 # Updates representing coefficients
├── updating_X.m                 # Updates signal estimate
├── reg.m                        # Regularization function for ℓ₁-trend filtering
├── circulant.m                  # Circulant matrix utility function
├── frames2vec.m                 # Combines the speech segments to form the complete signal 
├── README.md                    # Project documentation
