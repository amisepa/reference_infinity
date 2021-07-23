# reref_rest()

This function re-references continuous EEG data to REST/INFINITY (Reference Electrode Standardization Technique) average.

Because the EEGLAB REST plugin only allows GUI use (https://github.com/sccn/REST), this (beta) function allows automation of the defaults settings of the plugin.

Output: EEG data re-referenced to REST/INFINITY average (EEGLAB format)

This funciton uses the default head model (a 3-concentric sphere head model, more details can be seen in Dong et al., 2017).

This program calculates the leadfield matrix from the 3000 cortical dipoles (spherical equivalent dipoles, see 'corti869-3000dipoles.dat') and the newly given electrode array for the canonical concentric-three-spheres head model.
The radii of the three concentric spheres are 0.87(inner radius of the skull), 0.92(outer radius of the skull) and 1.0(radius of the head), while the conductivities are 1.0(brain and scalp) and 0.0125 (skull).

This code was adapted by Cedric Cannard (March 2021) to allow command use for automation of REST re-referencing.

The method and EEGLAB plugin were developed by Li Dong (Li_dong729@163.com) and Shiang Hu (hushiang@126.com): http://www.neuro.uestc.edu.cn/rest

References:
Yao D (2001) A method to standardize a reference of scalp EEG recordings to a point at infinity. Physiol Meas 22:693?11. doi: 10.1088/0967-3334/22/4/305
Li Dong, Fali Li, Qiang Liu, Xin Wen, Yongxiu Lai, Peng Xu and Dezhong Yao. MATLAB Toolboxes for Reference Electrode Standardization Technique (REST) of Scalp EEG. Frontiers in Neuroscience, 2017:11(601).

Usage: EEG = reref_rest(EEG);

Copyright (C) 2021 Cedric Cannard
