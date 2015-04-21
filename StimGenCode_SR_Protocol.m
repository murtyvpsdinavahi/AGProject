clear 
clc

Am = 1;
w = 0;%4:4:40;
Om = -2:0.4:2;
Ph = [0 0.25 0.5 0.75]*pi;
% Ori=4;

T0 = 1;
f0 = 250;
BW = 6;
SF = 32000;
CF = 1; % Log spacing of components
dfA = 20; % No. of frequencies per octave
df = 1/dfA; % Frequency spacing
RO = 0; % Roll-off
AF = 1; % Amplitude flag: Linear
Mo = 0.9; % Modulation Depth
wM = 120; % Maximum temporal velocity
PhFlag = 2;

% T0=T0/1000;
lengthSound = round((T0)*SF); 
timeAxis  = 0:1/SF:(lengthSound-1)/SF; % Time Axis (s)

cond = [T0, f0, BW, SF,   CF, df, RO, AF, Mo, wM, PhFlag];
comp_phs_file='C:\Users\LabComputer6\Documents\MATLAB\Programs\Murty\Project related\Sounds\save_comp_phs_Baphy';


Azi=1;

rampTime=0.01; % rampTime in seconds


hPhW = waitbar(0,'Phases...');
hOmW = waitbar(0,'Ripple Frequencies...');
hlW = waitbar(0,'Ripple Velocities...');

lOm = length(Om);
lw = length(w);
lPh = length(Ph);
for Ori=1:lPh    
    waitbar(Ori/lPh,hPhW,'Phases...');
    for i=1:lOm        
        waitbar(i/lOm,hOmW,'Ripple Frequencies...');        
        FolderName = (['C:\Users\LabComputer6\Documents\MATLAB\Programs\Murty\Project related\Sounds\Protocols_Baphy\SR Protocol\Phase ' num2str(Ph(Ori)/pi) '\']);
        diary([FolderName 'StimulusReport.txt']);
        disp('T0,           f0,             BW,             SF,             CF,             df,             RO,             AF,             Mo,             wM,             PhFlag');
        disp(num2str(cond));
        disp(['loading component phases from ' comp_phs_file]);
        for j=1:lw             
            waitbar(j/lw,hlW,'Ripple Velocities...');
            disp([char(10) 'New Sound']);
            disp([char(10) 'Am      w       Om      Ph']);
            
            % Baphy code
            rippleList = [Am w(j) Om(i) Ph(Ori)];
            disp(num2str(rippleList));
            [soundFile,profile] = multimvripfft1(rippleList, cond,comp_phs_file);
            soundFile=soundFile';
            
            % Normalise (MD)
            [normalisedSound] = soundNormalise(soundFile,'max');
            
            % Apply Ramp (MD)
            [rampedSound] = rampSound(normalisedSound,timeAxis,rampTime,'Hanning');
            
            % Save file
            FileName = ['Azi' num2str(Azi) 'SF' num2str(i) 'Ori' num2str(Ori) 'TF' num2str(j)];
            audiowrite([FolderName FileName '.wav'],rampedSound,SF);
            disp(['Saved sound file: ' FileName '.wav to folder: ' FolderName]);
        end
        diary('off');
    end
end
close(hlW)
close(hOmW)
close(hPhW)
