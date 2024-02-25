function [names, allIds] = netcdf_getnames(fileId)

allIds = netcdf.inqVarIDs(fileId);
for iId = 1:numel(allIds)
    thisId = allIds(iId);
    names{iId,1} = netcdf.inqVar(fileId, thisId);
end

end