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
    
    window = 50; %Window size
    w =  round((window -1) /2);
    n = len;
    %for i = w + 1 : n - w - 1
     %   medianFiltred(i) = median(data(i - w : i + w));
    %end
    %data = medianFiltred;

    %%%%%%%%%%%%%%%%%%
    %%Calculating Fourier transform and power spectrum 
    powerSpec = abs(fft(data) ./ len).^2;

    pureName = split(files(k).name, '.');
    pureName = pureName(1)%%Pure name of the audio file
    
    %%%%%%%%%%%%%%%%%%
    %%Finding mean
    mean = meanFinder(powerSpec, maxF, time)
    
    %if(mean >= 122 - 75 && mean < 122 + 48)      
    %    movefile (strcat(folderName,'/', files(k).name) ,  char(strcat(folderName,'/',pureName, ' -Male.mp3')));
    %elseif(mean >= 212 - 48 && mean < 212 + 75 )
    %    movefile (strcat(folderName,'/', files(k).name) ,  char(strcat(folderName,'/',pureName, ' -Female.mp3')));
    %else
    %    movefile (strcat(folderName,'/', files(k).name) ,  char(strcat(folderName,'/',pureName, ' -Unknown.mp3')));
    %end
    
end




function mean = meanFinder(powSpec,maxF, time)
    den = 0;
    temp = 0;
    for i=1:1:maxF
        temp = temp + i * powSpec(i);
        den = den + powSpec(i);
    end
    mean = temp / (den * time * 2);
end

