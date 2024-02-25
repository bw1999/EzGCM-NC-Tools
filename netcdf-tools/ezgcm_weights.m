function [weights, latGrid, lonGrid] = ezgcm_weights()

SavedStruct = load("ezgcm_weights.mat");
weights = SavedStruct.weights;
latGrid = SavedStruct.latGrid;
lonGrid = SavedStruct.lonGrid;

end