% This function references EEG data to infinity using REST (reference 
% electrode standardization technique). The algorithm calculates the 
% leadfield matrix from 3000 spherical equivalent dipoles and uses the 
% canonical concentric-three-spheres head model by default. 
% The radii of the 3 concentri spheres are:
%   - 0.87 (inner radius of the skull)
%   - 0.92 (outer radius of the skull)
%   - 1.0 (radius of the head)
% The conductivities are:
%   - 1.0 (brain and scalp) 
%   - 0.0125 (skull).
% If input data are epoched, they are automatically converted back to
% continuous for referencing, and reshaped to epoched at the end.
% If electrode locations are not already loaded, they are imported
% automatically using the standard 10-05 BEM template.
%  
% INPUTS:
%   EEG         - EEG structure in the EEGLAB format (must contain electrode locations)
%   'leadfield' - file name and path containing leadfield (G). default:
%                 calculated from electrodes and dipoles XYZ coordinates.
%   'dipoles'   - file name and path containing the fixed dipoles. default: 'corti869-3000dipoles.dat'
% 
% OUTPUT:
%   EEG         -  EEG structure in EEGLAB format with data referenced to infinity.
% 
% EXAMPLES: 
%   EEG = ref_infinity(EEG);  % default settings
%   EEG = ref_infinity(EEG,'chanlist',1:10);    % reference only channels 1-10
%   EEG = ref_infinity(EEG,'dipoles','corti869-3000dipoles.dat');    % specify the dipoles files
% 
% Warning: not validated for less than 30 EEG channels and could result in
% unknown data transformations.
% 
% References:
%   - Yao (2001). A method to standardize a reference of scalp EEG recordings 
%       to a point at infinity. Physiol Meas.
%   - Yao et al. (2005). A comparative study of different references for 
%       EEG spectral mapping: the issue of the neutral reference and the use of 
%       the infinity reference
%   - Marzetti et al. (2007). The use of standardized infinity reference in 
%       EEG coherency studies. Neuroimage.
%   - Qin et al. (2010). A comparative study of different references for EEG 
%       default mode network: The use of the infinity reference. Clin Neurophysio.
%   - Nunez (2010). REST: A Good Idea but Not the Gold Standard. Clin Neurophysio.
%   - Chella et al. (2016). Impact of the reference choice on scalp EEG 
%       connectivity estimation. Journal of Neural Engineering.
%   - Chella et al. (2017). Non-linear Analysis of Scalp EEG by Using 
%       Bispectra: The Effect of the Reference Choice. Frontiers in Human
%       Neuroscience. 
%   - Dong et al. (2017). MATLAB Toolboxes for Reference Electrode 
%       Standardization Technique (REST) of Scalp EEG. Frontiers in Neuroscience.
%   - Lei et al. (2017). Undestanding the Influences of EEG Reference: A 
%       Large-Scale Brain Network Perspective. Frontiers in Neuroscience. 
%   - Qin et al. (2017). A Comparative Study on the Dynamic EEG Center of 
%       Mass with Different References. Frontiers in Neuroscience. 
%   - Yang et al. (2017). A Comparative Study of Average, Linked Mastoid, 
%       and REST References for ERP Components Acquired during fMRI.
%       Frontiers in Neuroscience. 
%   - Hu et al. (2018). How do reference montage and electrodes setup affect 
%       the measured scalp EEG potentials? Journal of Neural Engineering.
%   - Zheng et al (2018). A Comparative Study of Standardized Infinity Reference 
%       and Average Reference for EEG of Three Typical Brain
%       States. Frontiers in Neuroscience. 
%   - Yao et al. (2019). Which Reference Should We Use for EEG and ERP
%       practice?.Brain Topography. 
%   - Hu et al. (2019). The Statistics of EEG Unipolar References: Derivations
%       and Properties. 
%   - Dong et al. (2023). Rereferencing of clinical EEGs with nonunipolar 
%       mastoid reference to infinity reference by REST. Clinical Neurophysiology.
%
% Original code from the REST plugin (Dong et al. 2017). Modified by Cedric
% Cannard to allow command line use, but using the same default parameters, 
% and head model. 
% 
% Copyright (C) - Cedric Cannard, 2021

function [EEG, com] = ref_infinity(EEG,varargin)

% Checks
if isempty(EEG.data)
    error('EEG.data is empty. Import data in EEGLAB first');
end
if isempty(EEG.chanlocs) || ~isfield(EEG.chanlocs,'X') || isempty(EEG.chanlocs(1).X)
    % error('You need to load your electrode coordinates first. Go to Edit > Channel locations');
    warning('This dataset does not have electrode locations. Loading the default BEM coordinate template')
    dipfitPath = fileparts(which('dipfitdefs.m'));
    EEG = pop_chanedit(EEG,'lookup',fullfile(dipfitPath,'standard_BEM','elec','standard_1005.elc'));
end
if EEG.nbchan < 30
    warning('This referencing method has not beed validated for less than 30 channels and may result in unknnown transformations of your data.'); 
end

% if epoched, convert back to continuous
if length(size(EEG.data)) == 3
    % error('Data must be continuous (not epoched)');
    warning('Epoched data detected. Converting back to continuous to re-reference to infinity.')
    EEG.data = EEG.data(:,:);
    epoched = 1;
else
    epoched = 0;
end

% Parameters
if nargin > 1
    inputs = varargin(1:2:end);

    % leadfield file
    idx = find(contains(inputs,'leadfield'));
    if ~isempty(idx)
        leadfield = varargin{idx(2)};
    else
        leadfield = [];     % default
    end

    % Dipoles file
    idx = find(contains(inputs,'dipoles'));
    if ~isempty(idx)
        dipoles = varargin{idx(2)};
    else
        dipoles = 'corti869-3000dipoles.dat';   % default
    end
else
    % exclude = [];
    leadfield = [];     % default
    dipoles = 'corti869-3000dipoles.dat'; % default
end

% Ensure double precision
EEG.data = double(EEG.data);

% Channels to exlude
chanlist = 1:EEG.nbchan;  
% if ~isempty(exclude)
%     % chanlist(chanIdx) = [];
%     warning('Excluding %g channels from referencing.',length(exclude))
%     chanIdx = contains({EEG.chanlocs.labels},exclude);
%     if sum(chanIdx) > 0
%         chanlist(chanIdx) = [];
%         % tmpdata = EEG.data(chanIdx,:);
%         % tmplocs = EEG.chanlocs(chanIdx);
%         % EEG = pop_select(EEG,'nochannel',exclude);
%     else
%         warning("the channels you want to exclude were not recognized. PLease make sure they are present in your dataset")
%     end
% end

% Get elec XYZ coordinates to calculate leadfield
xyz_elec = zeros(length(chanlist),3);
for nc = 1:length(chanlist)
    xyz_elec(nc,1) = EEG.chanlocs(chanlist(nc)).X;
    xyz_elec(nc,2) = EEG.chanlocs(chanlist(nc)).Y;
    xyz_elec(nc,3) = EEG.chanlocs(chanlist(nc)).Z;
end

% Calculate dipole orientations.
dipoles = load(dipoles);
xyz_dipOri = bsxfun(@rdivide, dipoles, sqrt(sum(dipoles.^ 2, 2)));
xyz_dipOri(2601: 3000, 1) = 0;
xyz_dipOri(2601: 3000, 2) = 0;
xyz_dipOri(2601: 3000, 3) = 1;

% Define head model
headmodel        = [];
headmodel.type   = 'concentricspheres';
headmodel.o      = [ 0.0000 0.0000 0.0000 ];
headmodel.r      = [ 0.8700,0.9200,1];
headmodel.cond   = [ 1.0000,0.0125,1];
headmodel.tissue = { 'brain' 'skull' 'scalp' };

% Calculate leadfield
disp('Calculating leadfield based on 3-concentric spheres headmodel...');
[G,~] = dong_calc_leadfield3(xyz_elec,dipoles,xyz_dipOri,headmodel);
fprintf('Lead field matrix: %g sources & %g channels \n',size(G,1),size(G,2));

% Check size match
% if size(EEG.data,1)-length(exclude) ~= size(G,1)
if size(EEG.data,1) ~= size(G,1)
        error('No. of Channels in lead field matrix and EEG data are not equal. This may be due to AUX channels still present in the data.');
end

% Ref to average
EEG.data = EEG.data - repmat(mean(EEG.data),size(EEG.data,1),1);

% Reference to infinity
Gar = G - repmat(mean(G),size(G,1),1);
tol = 0.05; % 0.05 for real data (0 for simulated data). treats values < tol as 0
data_z = G * pinv(Gar,tol) * EEG.data; 
data_z = EEG.data + repmat(mean(data_z), size(G,1),1); % V = V_avg + AVG(V_0)
EEG.data = data_z;
EEG.ref = 'rest';

% Convert data back to epoched
if epoched
    EEG.data = reshape(EEG.data, EEG.nbchan, EEG.pnts, EEG.trials);
end

% final check
EEG = eeg_checkset(EEG);
disp('EEG data were successfully referenced to infinity.');

% eegh
com = "EEG = ref_infinity(EEG);";

% cite
fprintf("When using this code, please cite: \n    Yao (2001) A method to " + ...
    "standardize a reference of scalp EEG recordings to a point at infinity. \n " + ...
    "   Dong et al. (2017). MATLAB Toolboxes for Reference Electrode Standardization " + ...
    "Technique (REST) of Scalp EEG. \n")
