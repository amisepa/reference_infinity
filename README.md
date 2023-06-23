# reref_infinity()
This EEGLAB plugins allows re-referening EEG data (continuous or epoched) to infinity using the reference electrode standardization technique (REST).
Because the REST plugin developed by Dong et al. (2017) can only be used with the GUI, it cannot be automated to process files automatically. 
This plugin allows to use the REST method via commad line, using the default parameters and 3-concentric sphere head model. 
By default, the leadfield matrix is calculated from the electrodes cartesian coordinates. Users can input a different leadfield matrix or dipoles file, if needed. 

Please cite these references when using this code:
Yao (2001). A method to standardize a reference of scalp EEG recordings to a point at infinity. Physiol Meas.
Dong et al. (2017). MATLAB Toolboxes for Reference Electrode Standardization Technique (REST) of Scalp EEG. Frontiers in Neuroscience.

## Requirements
- EEG data imported into EEGLAB without auxiliary electrodes (option to exclude specific electrodes coming soon)
- data must have at least 30 electrodes to be reliable
- channel locations loaded in the EEG structure (if not loaded, the plugin imports the default BEM coordinates template)

## Requirements
1) Have MATLAB and EEGLAB installed
2) Install the plugin via:
    - the EEGLAB GUI: File > Manage extensions > ref_rest_cmd
    - unzipping or cloning this Github repo into the EEGLAB's "plugins" folder
3) Import EEG data into EEGLAB and remove auxiliary electrodes (option to exclude specific electrodes from the referencing not currently available)
4) Have at least 30 electrodes to get reliable results
5) channel locations loaded in the EEG structure (although the plugin will import the default BEM coordinates if not already loaded)

## Usage

EEG = reref_inf(EEG);                                           % reference to infinity using default parameters

EEG = reref_inf(EEG, ,'leadfield','your_leadfield_file');       % specify another leadfield file

EEG = reref_inf(EEG, ,'dipoles','corti869-3000dipoles.dat');    % specify another dipoles file

## Quick tests on sample data

Sample data referenced to REST: GUI method vs command method --> showing no differences (as intended)
![rest_cmd-rest_gui](https://github.com/amisepa/reference_infinity/assets/58382227/4c10c2d5-70bf-4f81-bb80-6ba512f9dcee)



## Other relevant references comparing/validating the infinity/REST reference:

Yao et al. (2005). A comparative study of different references for EEG spectral mapping: the issue of the neutral reference and the use of the infinity reference

Marzetti et al. (2007). The use of standardized infinity reference in EEG coherency studies. Neuroimage.

Qin et al. (2010). A comparative study of different references for EEG default mode network: The use of the infinity reference. Clin Neurophysio.

Nunez (2010). REST: A Good Idea but Not the Gold Standard. Clin Neurophysio.

Chella et al. (2016). Impact of the reference choice on scalp EEG connectivity estimation. Journal of Neural Engineering.

Chella et al. (2017). Non-linear Analysis of Scalp EEG by Using Bispectra: The Effect of the Reference Choice. Frontiers in Human Neuroscience. 

Dong et al. (2017). MATLAB Toolboxes for Reference Electrode Standardization Technique (REST) of Scalp EEG. Frontiers in Neuroscience.

Lei et al. (2017). Undestanding the Influences of EEG Reference: A Large-Scale Brain Network Perspective. Frontiers in Neuroscience. 

Qin et al. (2017). A Comparative Study on the Dynamic EEG Center of Mass with Different References. Frontiers in Neuroscience. 

Yang et al. (2017). A Comparative Study of Average, Linked Mastoid, and REST References for ERP Components Acquired during fMRI. Frontiers in Neuroscience. 

Hu et al. (2018). How do reference montage and electrodes setup affect the measured scalp EEG potentials? Journal of Neural Engineering.

Zheng et al (2018). A Comparative Study of Standardized Infinity Reference and Average Reference for EEG of Three Typical Brain States. Frontiers in Neuroscience. 

Yao et al. (2019). Which Reference Should We Use for EEG and ERP practice?. Brain Topography.

Hu et al. (2019). The Statistics of EEG Unipolar References: Derivations and Properties. 

Dong et al. (2023). Rereferencing of clinical EEGs with nonunipolar mastoid reference to infinity reference by REST. Clinical Neurophysiology.
