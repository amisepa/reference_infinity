# reref_infinity()
This function re-references continuous EEG data to infinity using the code from the REST EEGLAB plugin (https://github.com/sccn/REST). Because the REST plugin can only be used manually through the user interface, it cannot be automated in scripts to re-reference large datasets. Hence, this function implements the same code but through command line. 

## Parameters
Defaults parameters are used, including default 3-concentric sphere head model. Selection of other head models coming soon. 
The function calculates the electric leadfield  matrix for dipoles in concentric spheres, from the 3000 cortical dipoles (spherical equivalent dipoles, see 'corti869-3000dipoles.dat'). 
The resulting output is an electrode array for the canonical concentric-three-spheres head model. 
The radii of the 2 concentri spheres are 0.87 (inner radius of the skull), 0.92 (outer radius of the skull) and 1.0 (radius of the head), while the conductivities are 1.0 (brain and scalp) and 0.0125 (skull).

## Requirements
- Continuous EEG data imported in EEGLAB
- a montage with at least 16 channels
- channel locations loaded in the EEG structure

## Usage

EEG = reref_inf(EEG);


## Please cite these references when using this function:

Yao, D. (2000). "High-resolution EEG mappings: a spherical harmonic spectra theory and simulation results." Clin Neurophysiol 111(1): 81-92.

Yao, D, (2001). "A method to standardize a reference of scalp EEG recordings to a point at infinity". Physiol Meas 22:693?11. doi: 10.1088/0967-3334/22/4/305

Li Dong, Fali Li, Qiang Liu, Xin Wen, Yongxiu Lai, Peng Xu and Dezhong Yao (2017). "MATLAB Toolboxes for Reference Electrode Standardization Technique (REST) of Scalp EEG". Frontiers in Neuroscience, 2017:11(601).

