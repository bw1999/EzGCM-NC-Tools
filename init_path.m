% Adds all folders that are below this to the path
thisFileDir = fileparts(mfilename('fullpath'));
addpath(genpath(thisFileDir));