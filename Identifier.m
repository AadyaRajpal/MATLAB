%%Reading audio file
folderName = input('Enter name of the voices folder:');
address = strcat(folderName,'/*.mp3');
files = dir(address);
numFiles = length(files);

%%%%%%%%%%%%%%%%
%%Reading and analysing files one by one
for k = 1 : numFiles
    thisFileName = fullfile(files(k).folder, files(k).name);
    [data,fs] = audioread(thisFileName);
    
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
    %%Finding peak
    peak = peakFinder(powerSpec,maxF,time);

    pureName = split(files(k).name, '.');
    pureName = pureName(1);%%Pure name of the audio file
    
    if(peak >= 122 - 75 && peak < 122 + 45)      
        movefile (strcat(folderName,'/', files(k).name) ,  char(strcat(folderName,'/',pureName, ' -Male.mp3')));
    elseif(peak >= 212 - 45 && peak < 212 + 45 )
        movefile (strcat(folderName,'/', files(k).name) ,  char(strcat(folderName,'/',pureName, ' -Female.mp3')));
    else
        movefile (strcat(folderName,'/', files(k).name) ,  char(strcat(folderName,'/',pureName, ' -Unknown.mp3')));
    end
    
end




function peak = peakFinder(powSpec,maxF,time)
    max = 0;
    index = 0;
    for i=1:1:maxF
        if(powSpec(i) > max)
            max = powSpec(i);
            index = i;
        end
    end
    peak = index / time;
end

