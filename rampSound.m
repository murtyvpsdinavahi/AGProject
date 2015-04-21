%% [rampedSound,rampingFilter] = rampSound(soundFile,timeVals,rampTime,ramp)
% Input arguments:
% timeVals
% rampTime: is in same units as timeVals
% optional: 
% 1. ramp:
%    1. 'SquaredSine'
%    2. 'Hanning' (Default)
% 2. soundFile
% 
% Output arguments:
% rampedSound:
% rampingFilter
%
% Murty V P S Dinavahi 20/04/2015
%

function [rampedSound,rampingFilter] = rampSound(soundFile,timeVals,rampTime,ramp,PlotFlag) % rampTime is in seconds

%% Set defaults
if ~exist('ramp','var'); ramp='Hanning'; end
if ~exist('PlotFlag','var'); PlotFlag=0; end

%% Calculate time-domain ramping filter
rampPonits=timeVals(1:(find(timeVals>=rampTime,1))-1);
rampPonits=rampPonits./max(rampPonits);

switch ramp
    case 'SquredSine'
        disp(['Applying squared sine ramp of ' num2str(rampTime) ' sec']);
        a=sin(0.5*pi*rampPonits);
        a=(a./max(a)).^2;
    case 'Hanning'
        disp(['Applying hanning ramp of ' num2str(rampTime) ' sec']);
        a=hanning(length(rampPonits)*2)';
        a = a(1:floor(length(a)/2));
        a=(a./max(a));
end

b=ones(1,(length(timeVals)-(2*(length(a)))));
c=soundReverse(a);
rampingFilter=[a b c];

%% Plot filter if PlotFlag
if PlotFlag
    figure(2345); plot(timeVals,rampingFilter);
end
%% Apply filter
if ~isempty(soundFile)
    rampedSound=soundFile.*rampingFilter;
else
    rampedSound = [];
end

end