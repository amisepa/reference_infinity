% eegplugin_ref_infinity() - EEGLAB plugin for referencing EEG data to
% infinity using Reference Electrode Standardization Technique (REST) via
% command line for automated processing. 
%
% Copyright (C) - Cedric Cannard, June 2023
% 
% Original code by Yao (2001) and Dong et al. (2017).
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function vers = eegplugin_ref_infinity_cmd(fig,try_strings,catch_strings)

% Plugin version
vers = '1.0';

% Add paths to subfolders
p = fileparts(which('eegplugin_ref_infinity_cmd.m'));
addpath(p);
addpath(fullfile(p,'sample_data'))
addpath(fullfile(p,'files'))

cmd = [ try_strings.check_data '[EEG,LASTCOM] = ref_infinity(EEG);' catch_strings.new_and_hist ];

% menu
toolsmenu = findobj(fig, 'tag', 'tools');
uimenu(toolsmenu, 'label', 'Reference data to infinity (REST) via command line','userdata', ...
    'startup:off;epoch:off;study:off','callback',cmd,'position',4);
