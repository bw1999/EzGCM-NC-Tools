function weightGrid = determine_area_weights(latVec, lonVec, varargin)
% Computes weights for each vector element based on the local area
% Note! Assumes even spacing but isn't fullproof. Recommend using
% precomputed weights in 'ezgcm_weights.mat'
%
%   Optional Arguments:
%   - earthModel:   Defaults to using a spherical earth, also allows 'wgs84'
%   
%   - latDim:       Defaults to netcdf format used by EzGCM, but can be switched
%


% Read optional inputs
P = inputParser();
               % Property name  % Default
P.addParameter('earthModel',    'sphere')
P.addParameter(    'latDim',           2)
P.parse(varargin{:})
Input = P.Results;

switch lower(Input.earthModel)
    case 'sphere'
        earthModel = referenceSphere('earth');
    case 'wgs84'
        earthModel = referenceEllipsoid('wgs84');
    otherwise
        error('Invalid earthModel input given. Use either ''sphere'', or ''wgs84''')
end

% areaquad requires input to be of type double
latVec = double(latVec);
lonVec = double(lonVec);

% Get the spacing and find the midpoints between all data
latMidpoints = movmean(latVec, [1 0]);
latMidpoints(end+1) = latMidpoints(end) + abs(latMidpoints(end) - latVec(end));
lat1s = latMidpoints(1:end-1);
lat2s = latMidpoints(2:end);

lonSpacing = mode(diff(lonVec));
lon1s = lonVec - lonSpacing/2;
lon2s = lonVec + lonSpacing/2;

% Create gridded versions of these to feed all data points into the areaquad function
[lat1Grid, lon1Grid] = meshgrid(lat1s, lon1s);
[lat2Grid, lon2Grid] = meshgrid(lat2s, lon2s);
areas = areaquad(lat1Grid(:), lon1Grid(:), lat2Grid(:), lon2Grid(:), earthModel, 'degrees');

% Reshape and convert into a percentage of the globe
weightGrid = reshape(areas, [numel(lonVec), numel(latVec)]) / sum(areas);


end