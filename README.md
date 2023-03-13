# reref_infinity()
This function re-references continuous EEG data to INFINITY (Reference Electrode % Standardization Technique) average. 

Because the EEGLAB REST plugin (https://github.com/sccn/REST) only allows GUI use, this function implements the same code but through command line automation.

Defaults parameters are used, including default head model. Selection of head model coming soon.  

Usage:

EEG = reref_inf(EEG);
