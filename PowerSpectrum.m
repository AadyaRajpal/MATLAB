%%Reading audio file
name = input('Enter name of the voice:');
address = strcat('voices/',name,'.mp3');
[data,fs] = audioread(address);

%%%%%%%%%%%%%%%%%%
%%Setting constants
len = length(data);
maxF = 20000;
time = len / fs;
points = fs * time;
hz = linspace(0, fs,points);

%%%%%%%%%%%%%%%%%%
%%Calculating Fourier transform and power spectrum 
powerSpec = abs(fft(data) ./ len).^2;

%%%%%%%%%%%%%%%%%%
%%Ploting the power spectrum
stem(hz(1:maxF), powerSpec(1:maxF),'Marker','none' );
plotName = strcat('Power spectrum of :', name);
title(plotName);
xlabel('Frequency(Hz)');
ylabel('Power spectrum');
peakFinder(powerSpec, maxF, time);
function peak = peakFinder(powSpec,maxF,time)
    max = 0;
    index = 0;
    for i=1:1:maxF
        if(powSpec(i) > max)
            max = powSpec(i);
            index = i;
        end
    end
    peak = index / time
end

