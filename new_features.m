function featureVector = extract_features(data, fs)
% --- Configuration Parameters ---
frameSize = 0.025 * fs; % 25 ms frame size
overlap = 0.010 * fs;   % 10 ms overlap (15 ms step)
window = hamming(frameSize, 'periodic');
numFrames = floor((length(data) - frameSize) / (frameSize - overlap)) + 1;

% Reshape the data into overlapping frames
framedData = buffer(data, frameSize, overlap, 'nodelay');
% Apply windowing to each frame
windowedData = framedData .* window;

% --- 1. Zero-Crossing Rate (ZCR) ---
ZCR = zeros(1, numFrames);
for i = 1:numFrames
    frame = windowedData(:, i);
    % Calculate the number of sign changes
    signChanges = sum(abs(diff(sign(frame))) / 2);
    % ZCR is the number of zero crossings divided by the frame length
    ZCR(i) = signChanges / frameSize;
end

% ZCR is a vector of features (one per frame)
disp(['Mean ZCR: ', num2str(mean(ZCR))]);

% --- 2. Spectral Centroid & 3. Spectral Rolloff ---
SpectralCentroid = zeros(1, numFrames);
SpectralRolloff = zeros(1, numFrames);
rolloffPercent = 0.85; % Target 85% energy
NFFT = 2^nextpow2(frameSize);
f = fs/2 * linspace(0, 1, NFFT/2 + 1); % Frequency vector

for i = 1:numFrames
    frame = windowedData(:, i);
    
    % Compute the magnitude spectrum
    Y = fft(frame, NFFT);
    Pyy = abs(Y(1:NFFT/2 + 1));
    
    % Spectral Centroid
    SpectralCentroid(i) = sum(f .* Pyy') / sum(Pyy);
    
    % Spectral Rolloff
    totalEnergy = sum(Pyy);
    thresholdEnergy = totalEnergy * rolloffPercent;
    cumulativeEnergy = cumsum(Pyy);
    
    % Find the first frequency bin where cumulative energy exceeds the threshold
    rolloffIndex = find(cumulativeEnergy >= thresholdEnergy, 1, 'first');
    if isempty(rolloffIndex)
        SpectralRolloff(i) = fs / 2; % Set to max frequency if not found
    else
        SpectralRolloff(i) = f(rolloffIndex);
    end
end

disp(['Mean Spectral Centroid: ', num2str(mean(SpectralCentroid))]);
disp(['Mean Spectral Rolloff (85%): ', num2str(mean(SpectralRolloff))]);

% --- 4. Linear Predictive Coding (LPC) Coefficients ---
% The order 'p' should be chosen based on sampling rate (fs/1000 + 2 is a common heuristic)
p = round(fs/1000) + 2; 
LPC_Coeffs = zeros(p + 1, numFrames);

for i = 1:numFrames
    frame = windowedData(:, i);
    % The lpc function returns coefficients [1, a2, a3, ...]
    a = lpc(frame, p);
    LPC_Coeffs(:, i) = a';
end

% The feature set is the MEAN of the coefficients over all frames
meanLPC = mean(LPC_Coeffs, 2); 
disp(['LPC Order: ', num2str(p)]);
disp(['Mean LPC Coeffs (first 5): ', num2str(meanLPC(1:5)')]);

% --- 5. Short-Time Energy ---
Energy = zeros(1, numFrames);

for i = 1:numFrames
    frame = windowedData(:, i);
    % Energy is the sum of the square of the sample values
    Energy(i) = sum(frame.^2);
end

% This vector can be used for Voice Activity Detection (VAD)
disp(['Mean Short-Time Energy: ', num2str(mean(Energy))]);

% Combine all features into a single vector of means for the classifier
featureVector = [mean(ZCR), mean(SpectralCentroid), mean(SpectralRolloff), meanLPC'];

end