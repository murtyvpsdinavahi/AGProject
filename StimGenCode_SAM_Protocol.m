clear 
clc

Am = 1;
w = 4:4:40;
Om = 0;
Ph = 0;

T0 = 1;
f0 = [500 1000 2000 4000];
BW = 1;
SF = 32000;
CF = 1; % Log spacing of components
dfA = 1; % No. of frequencies per octave
df = 1/dfA; % Frequency spacing
RO = 0; % Roll-off
AF = 1; % Amplitude flag: Linear
Mo = 0.9; % Modulation Depth
wM = 120; % Maximum temporal velocity
PhFlag = 0;

lengthSound = round((T0)*SF); 
timeAxis  = 0:1/SF:(lengthSound-1)/SF; % Time Axis (s)


comp_phs_file='C:\Users\LabComputer6\Documents\MATLAB\Programs\Murty\Project related\Sounds\save_comp_phs_Baphy';

Azi=1;

rampTime=0.01; % rampTime in seconds

hPhW = waitbar(0,'Phases...');
hOmW = waitbar(0,'Ripple Frequencies...');
hlW = waitbar(0,'Ripple Velocities...');

lOm = length(f0);
lw = length(w);
lPh = length(Ph);
for Ori=1:lPh    
    waitbar(Ori/lPh,hPhW,'Phases...');
    for i=1:lOm        
        waitbar(i/lOm,hOmW,'Ripple Frequencies...');        
        FolderName = (['C:\Users\LabComputer6\Documents\MATLAB\Programs\Murty\Project related\Sounds\Protocols_Baphy\SAM Protocol\BaseFreq ' num2str(f0(i)) '\']);
        diary([FolderName 'StimulusReport.txt']);
        
        disp(['loading component phases from ' comp_phs_file]);
        for j=1:lw             
            waitbar(j/lw,hlW,'Ripple Velocities...');
            disp([char(10) 'New Sound']);
            
            
            % Baphy code
            cond = [T0, f0(i), BW, SF,   CF, df, RO, AF, Mo, wM, PhFlag];
            disp([char(10) 'T0,           f0,             BW,             SF,             CF,             df,             RO,             AF,             Mo,             wM,             PhFlag']);
            disp(num2str(cond));
            
            rippleList = [Am w(j) Om Ph(Ori)];
            disp('Am      w       Om      Ph');
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
