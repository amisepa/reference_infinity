# reref_infinity()
This function re-references continuous EEG data to INFINITY (Reference Electrode Standardization Technique) average. 

Because the EEGLAB REST plugin (https://github.com/sccn/REST) only allows GUI use, this function implements the same code but through command line automation.

Defaults parameters are used, including default head model (i.e. a 3-concentric sphere head model, for more details see references below). Selection of other head models coming soon. 

The function calculates the leadfield  matrix from the 3000 cortical dipoles (spherical equivalent dipoles, see 'corti869-3000dipoles.dat'). 
The output is an electrode array for the canonical concentric-three-spheres head model. The radii of the 2 concentri spheres are 0.87 (inner radius of the skull), 0.92 (outer radius of the skull) and 1.0 (radius of the head), while the conductivities are 1.0 (brain and scalp) and 0.0125 (skull).

## Requirements
- Continuous EEG data imported in EEGLAB
- a montage with at least 32 channels
- channel locations loaded in the EEG structure

## Usage

EEG = reref_inf(EEG);


## Please cite these references when using this function:

Yao D (2001) A method to standardize a reference of scalp EEG recordings to a point at infinity. Physiol Meas 22:693?11. doi: 10.1088/0967-3334/22/4/305

Li Dong, Fali Li, Qiang Liu, Xin Wen, Yongxiu Lai, Peng Xu and Dezhong Yao. MATLAB Toolboxes for Reference Electrode Standardization Technique (REST) of Scalp EEG. Frontiers in Neuroscience, 2017:11(601).
