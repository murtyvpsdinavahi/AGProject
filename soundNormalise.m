function [normalisedSound] = soundNormalise(originalSound,tag)

%% Set defaults
    if ~exist('tag','var'); tag='rms'; end; % Default: rms
    if size(originalSound,1)> size(originalSound,2)
        originalSound = originalSound';
    end

%% Normalise
    for i=1:size(originalSound,1)
        switch tag
            case 'max'
                maxSound = max(abs(originalSound(i,:)));
                
            case 'rms'
                maxSound = rms(originalSound(i,:));
        end
            disp(['rms of original sound: ' num2str(rms(originalSound(i,:)))]);
            normalisedSound(i,:)=originalSound(i,:)/maxSound;
            disp(['rms of normalised sound: ' num2str(rms(normalisedSound(i,:)))]);
    end
end