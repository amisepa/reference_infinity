% This function re-references continuous EEG data to REST/INFINITY (Reference Electrode
% Standardization Technique) average. 
% 
% Should not be used with less than 32 channels!
% 
% Uses the default head model (a 3-concentric sphere head model,
% more details can be seen in Dong et al., 2017). Calculates the leadfield 
% matrix from the 3000 cortical dipoles (spherical equivalent dipoles, 
% see 'corti869-3000dipoles.dat') and the newly given electrode array
% for the canonical concentric-three-spheres head model. 
% The radii of the three concentri spheres are 0.87(inner radius of the skull), 
% 0.92(outer radius of the skull) and 1.0(radius of the head), 
% while the conductivities are 1.0(brain and scalp) and 0.0125 (skull).
%
% This code is adapted from the REST plugin to allow command line for
% automation, using the default parameters and one head model. 
% 
% References:
% Yao D (2001) A method to standardize a reference of scalp EEG recordings
% to a point at infinity. Physiol Meas 22:693?11. doi: 10.1088/0967-3334/22/4/305
% Li Dong*, Fali Li, Qiang Liu, Xin Wen, Yongxiu Lai, Peng Xu and Dezhong Yao*.
% MATLAB Toolboxes for Reference Electrode Standardization Technique (REST)
% of Scalp EEG. Frontiers in Neuroscience, 2017:11(601).
%
% Usage: EEG = reref_rest(EEG);
%
% Cedric Cannard, 2021

function EEG = reref_inf(EEG)

disp('----------- RE-REFERENCING DATA TO REST/INFINITY AVERAGE ---------------');

if isempty(EEG.data)
    errordlg('EEG.data is empty. Import data in EEGLAB first'); return
end
if length(size(EEG.data)) == 3
    errordlg('Data must be continuous (not epoched)'); return
end

% Calculate leadfield using coordinates from EEG.chanlocs
channels = 1:EEG.nbchan;  %Channels to select for REST referencing (e.g. 1:EEG.nbchan)
if ~isempty(EEG.chanlocs(1).X) && ~isempty(EEG.chanlocs(1).Y) &&~isempty(EEG.chanlocs(1).Z)
    disp('Calculating leadfield based on 3-concentric spheres headmodel...');
    xyz_elec = zeros(length(channels),3);
    for nc = 1:length(channels)
        xyz_elec(nc,1) = EEG.chanlocs(channels(nc)).X;
        xyz_elec(nc,2) = EEG.chanlocs(channels(nc)).Y;
        xyz_elec(nc,3) = EEG.chanlocs(channels(nc)).Z;
    end
else
    errordlg('EEG coordinates (EEG.chanlocs.X/Y/Z) are empty, please load channel locations in EEGLAB first.','Data Error'); return
end

% Load fixed dipoles and define their orientations (file with dipole coordinates can be defined by GUI)
programPath = fileparts(which('pop_REST_reref.m'));
xyz_dipoles = load(fullfile(programPath,'corti869-3000dipoles.dat'));
% dipfitPath = fileparts(which('dipfitdefs.m'));
% load(fullfile(dipfitPath,'standard_BEM','standard_vol.mat'));         % head model compatible with Fieldtrip

% Calculate the dipole orientations.
xyz_dipOri = bsxfun(@rdivide, xyz_dipoles, sqrt(sum(xyz_dipoles.^ 2, 2)));
xyz_dipOri(2601: 3000, 1) = 0;
xyz_dipOri(2601: 3000, 2) = 0;
xyz_dipOri(2601: 3000, 3) = 1;

% Define headmodel
headmodel        = [];
headmodel.type   = 'concentricspheres';
headmodel.o      = [ 0.0000 0.0000 0.0000 ];
headmodel.r      = [ 0.8700,0.9200,1];
headmodel.cond   = [ 1.0000,0.0125,1];
headmodel.tissue = { 'brain' 'skull' 'scalp' };

% Calculate leadfield
[G,~] = dong_calc_leadfield3(xyz_elec,xyz_dipoles,xyz_dipOri,headmodel);

if size(EEG.data,1) ~= size(G,1)
    errordlg('No. of Channels in lead field matrix and EEG data are NOT equal!','Data Error');
    return
else

    % Reference to REST
    Gar = G - repmat(mean(G),size(G,1),1);
    data_z = G * pinv(Gar,0.05) * EEG.data;  %0.05 for real data (may be set to 0 for simulated data)
    data_z = EEG.data + repmat(mean(data_z),size(G,1),1); % V = V_avg + AVG(V_0)
        
    % Outputs
    EEG.data = data_z;
    EEG.ref = 'rest';
    EEG = eeg_checkset(EEG);
    disp('EEG data were successfully average-referenced to REST/INFINITY.');
end

