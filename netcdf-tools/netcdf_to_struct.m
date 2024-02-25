function OutStruct = netcdf_to_struct(fileID)

    [names,ids] = netcdf_getnames(fileID);

    OutStruct = struct();
    for iId = 1:numel(ids)
        OutStruct.(names{iId}) = netcdf.getVar(fileID, ids(iId));
    end
    

end