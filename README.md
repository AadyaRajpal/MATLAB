# Sound-Processing-Project
# Audio Feature Extraction (MATLAB)

This repository contains a MATLAB function `extract_features.m` that extracts common time-domain and frequency-domain features from an audio signal. These features are often used in **speech/audio classification**, **speaker recognition**, and **voice activity detection (VAD)** pipelines.

---

## Features Extracted

The function computes frame-based features using:
- **Frame size:** 25 ms  
- **Overlap:** 10 ms (15 ms hop)
- **Window:** Hamming window

For each frame, it extracts:

1. **Zero-Crossing Rate (ZCR)**
   - Measures how frequently the signal changes sign (useful for voicing/noise cues).

2. **Spectral Centroid**
   - The “center of mass” of the magnitude spectrum (brightness of sound).

3. **Spectral Rolloff (85%)**
   - The frequency below which 85% of spectral energy is contained.

4. **LPC (Linear Predictive Coding) Coefficients**
   - Captures vocal tract / spectral envelope information.
   - Order is chosen as:  
     `p = round(fs/1000) + 2`

5. **Short-Time Energy**
   - Sum of squared samples per frame (often used for VAD).

---

## Output

The function returns a **single feature vector** by taking the **mean** of each frame-level feature across the entire signal:
<img width="648" height="468" alt="image" src="https://github.com/user-attachments/assets/bafeeb2d-765b-41fa-b4b0-0a7d11d214f2" />
<img width="770" height="532" alt="image" src="https://github.com/user-attachments/assets/5195f2a5-7565-4338-b020-ebfdc4b69c54" />



