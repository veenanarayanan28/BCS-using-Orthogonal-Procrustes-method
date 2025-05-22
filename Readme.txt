**Signal Reconstruction from Blind Compressive Measurements using Procrustes Method**

A technique to reconstruct speech signals from their blind compressed measurements when the representing basis (sparsifying basis) is unknown.

The method uses:

**Orthogonal Procrustes method** to estimate the sparsifying basis.
**$\ell _1$-trend filtering** for signal refinement.













Main code : main_BCS_PM_speech.m
Input files: speech_A_Y_m32_rev4.mat
Functions:
For updating the set of representing coefficients : updating_C.m
For updating signal: updating_X.m,  reg.m, circulant.m
Functions used for combining the speech segments to form the complete signal : frames2vec.m
