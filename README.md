📊 **Signal Reconstruction from Blind Compressive Measurements using Procrustes Method**

This repository provides a MATLAB implementation of a technique to reconstruct speech signals from their blind compressed measurements, where the sparsifying basis is unknown. 
The method employs the Orthogonal Procrustes method to estimate the basis and refines the reconstructed signal using ℓ₁-trend filtering.

🧠 **Method Overview**

Blind compressed sensing involves recovering a signal from compressed measurements when the sparsifying transform is unknown. 

This implementation focuses on:

-Estimating the sparse representing coefficients using **Basis pursuit algorithm**.

-Estimating the unknown sparsifying basis using the **Orthogonal Procrustes method**.

-Estimating the Signal by applying **ℓ₁-trend filtering**

🗂️ **File Structure**

| **File Name**             | **Description**                                                |
| ------------------------- | -------------------------------------------------------------- |
| `main_BCS_PM_speech.m`    | Main script for signal reconstruction                          |
| `speech_A_Y_m32_rev4.mat` | Input speech data                                              |
|                           |                                                                |
| **Functions:**            |                                                                |
| `updating_C.m`            | Updates representing coefficients using Basis Pursuit          |
| `updating_X.m`            | Updates signal estimate                                        |
| `reg.m`                   | Regularization function for ℓ₁-trend filtering                 |
| `circulant.m`             | Generates circulant matrix for use in filtering or convolution |
| `frames2vec.m`            | Combines the speech segments to form the complete signal       |
| `README.md`               | Project documentation                                          |


🗂️ **Related Publication**

Narayanan, V., Abhilash, G., (2023). Signal reconstruction from blind compressive measurements using Procrustes
Method. Circuits Systems and Signal Processing, Vol. 42, pp. 2941- 2958. DOI: 10.1007/s00034-022-02246-6


