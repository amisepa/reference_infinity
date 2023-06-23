%% Compute power spectral density (PSD) or power for each EEG channel using
% MATLAB's pwelch method.  Defaults are Hamming taper on a 2-s window with
% 50% overlap, outputting the power spectral density (PSD). If data are
% epoched, they are automatically converted to continuous to allow longer
% windows and avoid edge artifacts.
% 
% Usage:
% [pwr, pwr_norm, f] = get_psd(data,fs,overlap,fRange,vis)
% [pwr, pwr_norm, f] = get_psd(EEG.data,EEG.srate,.5,[1 100],4,1);
% 
% Inputs:
%   EEG data    - channels x frames or channels x frames x epochs
%   fs          - sampling frequency
%   overlap     - overlapped segment averaging, e.g., .5 for 50% overlap (default)
%   freqRange   - frequency range to output, e.g. [1 100] (default)
%   winLength  - window length in s (default = 4)
%   vis         - visualize (true) or not (false)
% 
% Copyright (C) - Cedric Cannard, 2021

function [pwr, pwr_norm, f] = get_psd(data,fs,overlap,fRange,winLength,vis)

% Sampling rate
if ~exist('fs', 'var') || isempty(fs)
    errordlg('You need to provide the sampling rate Fs to use this function.'); return;
end
% fs = EEG.srate;

% Epoched vs continuous
if length(size(data)) == 2
    epoched = false;
    disp('Continuous data detected. Converting to continuous to estime PSD with longer overlapping windows.')
else
    epoched = true;
    disp('Epoched data detected. Converting them back to continuous.')
    data = data(:,:);
end

% Window size
if ~exist('winLength','var')
    winLength = 4;   % 4-s window by default
end
winSize = fs*winLength;  % in samples

% Taper method: hamming (default), hann, blackman, rectwin.
taperM = 'hamming'; 
fh = str2func(taperM);

% Overlap
if ~exist('overlap', 'var') || isempty(overlap)
    overlap = .5;
end
noverlap = floor(overlap*winSize); % convert overlap ratio to samples

% Frequency range default
if ~exist('fRange', 'var') || isempty(fRange)
    nyquist = fs/2;
    fRange = [1/nyquist nyquist]; 
end

% Power type default
if ~exist('type', 'var')
    type = 'psd';    
end

% nfft
if ~exist('nfft', 'var') 
    nfft = winSize;
end

fprintf('Estimating %s on frequencies %g-%g Hz using %s-tapered %g-s long windows with %g%% overlap to estimate ... \n', ...
    upper(type),fRange(1),fRange(2),taperM,winLength,overlap*100)

% Power spectral density (PSD)
nChan = size(data,1);
parfor iChan = 1:nChan
    [pwr(iChan,:), f(iChan,:)] = pwelch(data(iChan,:),fh(winSize),noverlap,nfft,fs,type);
    % [pwr(iChan,:), f] = pwelch(data(iChan,:),winSize,[],[],fs,type);
end
f = f(1,:);

% Truncate PSD to frequency range of interest (ignore freq 0)
mask = f >= fRange(1) & f <= fRange(2);
if f(mask(1)) == 0
    mask(1) = [];
end
f = f(mask); %f(1) = [];
pwr = pwr(:,mask);     

% Normalize to deciBels (dB)
pwr_norm = 10*log10(pwr);

% Visualize
if vis
    figure('color','w');

    subplot(2,1,1)
    for iChan = 1:nChan
        plot(f,pwr(iChan,:)); hold on;
    end
    title('Power spectral density (PSD)'); ylabel('µV^2/Hz')
    box on; grid on; axis tight

    subplot(2,1,2)
    for iChan = 1:nChan
        plot(f,pwr_norm(iChan,:)); hold on;
    end
    title('Power spectral density (normalized)'); ylabel('dB (10*log10(µV^2/Hz)')
    box on; grid on; axis tight
end
