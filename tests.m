%% Tutorial

clear; close all; clc
eeglab; close;

mainPath = fileparts(which('ref_infinity'));
dataDir = fullfile(mainPath,'sample_data');
cd(mainPath)

% Load sample data (not referenced but clean)
EEG = pop_loadset('filename','sample_data.set','filepath',dataDir);

% Re-reference continuous data to infinity
restEEG = ref_infinity(EEG);

%% Load sample data referenced to REST using GUI to make sure they are the same

restEEG2 = pop_loadset('filename','sample_data_rest.set','filepath',dataDir);
vis_artifacts(restEEG,restEEG2);

%% Compare with average reference

avEEG = pop_reref(EEG,[]);

% Compare signals
% vis_artifacts(oriEEG,restEEG);
vis_artifacts(restEEG,avEEG);

% Compare PSD
elec = find(strcmpi({EEG.chanlocs.labels},'FCZ'));
% [~, pwr_ori, f] = get_psd(EEG.data,EEG.srate,.5,[1 30],4,0);
[~, pwr_av, f] = get_psd(avEEG.data,EEG.srate,.5,[1 30],4,0);
[~, pwr_rest, f] = get_psd(restEEG.data,EEG.srate,.5,[1 30],4,0);
figure('color','w'); plotDiff(f, pwr_av', pwr_rest','Trimmed mean',[],'AV','REST')
title('Power spectral density (95% CI on electrodes')

% Scalp topo theta and alpha 
theta_av = mean(pwr_av(:,f>=3 & f<=7),2);
theta_rest = mean(pwr_rest(:,f>=3 & f<=7),2);
alpha_av = mean(pwr_av(:,f>=8 & f<=13),2);
alpha_rest = mean(pwr_rest(:,f>=8 & f<=13),2);
figure('color','w')
subplot(2,2,1)
topoplot(theta_av,EEG.chanlocs); colorbar; title('Theta AV')
subplot(2,2,2)
topoplot(theta_rest,EEG.chanlocs); colorbar; title('Theta REST')
subplot(2,2,3)
topoplot(alpha_av,EEG.chanlocs); colorbar; title('Alpha AV')
subplot(2,2,4)
topoplot(alpha_rest,EEG.chanlocs); colorbar; title('Alpha REST')

% Compare grand average ERP + topo of peak effect 
EEG = pop_epoch(EEG, {'4' '8'}, [-0.1 1.1]); %4 = neutral; 8 = unpleasant;
avEEG = pop_epoch(avEEG, {'4' '8'}, [-0.1 1.1]); % 4 = neutral; 8 = unpleasant;
restEEG = pop_epoch(restEEG, {'4' '8'}, [-0.1 1.1]); %4 = neutral; 8 = unpleasant;
figure; pop_timtopo(EEG, [EEG.times(1) EEG.times(end)], []);
figure; pop_timtopo(avEEG, [EEG.times(1) EEG.times(end)], []);
figure; pop_timtopo(restEEG, [EEG.times(1) EEG.times(end)], []);

% Compare ERP between unpleasant and neutral trials
elec = find(strcmpi({EEG.chanlocs.labels},'POZ'));
figure('color','w'); 
subplot(3,1,1)
neutral = pop_epoch(EEG, {'4'}, [-0.05 1],'epochinfo','yes');
unpleasant = pop_epoch(EEG, {'8'}, [-0.05 1],'epochinfo','yes');
plotDiff( unpleasant.times, squeeze(unpleasant.data(elec,:,:)), squeeze(neutral.data(elec,:,:)),'Trimmed mean',[],'unpleasant','neutral')
title('Original data'); box on; grid on;
subplot(3,1,2)
neutral = pop_epoch(avEEG, {'4'}, [-0.05 1],'epochinfo','yes');
unpleasant = pop_epoch(avEEG, {'8'}, [-0.05 1],'epochinfo','yes');
plotDiff( unpleasant.times, squeeze(unpleasant.data(elec,:,:)), squeeze(neutral.data(elec,:,:)),'Trimmed mean',[],'unpleasant','neutral')
title('AV-ref'); box on; grid on;
subplot(3,1,3)
neutral = pop_epoch(restEEG, {'4'}, [-0.05 1],'epochinfo','yes');
unpleasant = pop_epoch(restEEG, {'8'}, [-0.05 1],'epochinfo','yes');
plotDiff( unpleasant.times, squeeze(unpleasant.data(elec,:,:)), squeeze(neutral.data(elec,:,:)),'Trimmed mean',[],'unpleasant','neutral')
title('REST-ref'); box on; grid on;
