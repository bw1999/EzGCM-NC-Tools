classdef NC_File < handle
    %NC_FILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

        % List of latvector points
        latVec

        % List of lonvector points
        lonVec

        % Grid of lat values
        latGrid

        % Grid of lon values
        lonGrid

        % Vector of years present in the dataset (from filename)
        year

        % Original name of the file
        filename

        % Where the file was taken from (if known)
        dirname

        % Model used (taken from the filename)
        model

    end
    
    properties (Dependent)

        % The list of fields in the dataset
        fields

    end


    properties (Hidden)

        % netcdf library file id. Used to reference file
        fileId

    end

    
    methods
        function obj = NC_File(file_path)
            
            % If input is a ir of files, load them all
            if iscell(file_path) && numel(file_path) > 1
                for iFile = 1:numel(file_path)
                    obj(iFile) = NC_File(file_path({iFile}));
                end
                return
            end

            % Get basic information about the file
            [obj.dirname, obj.filename] = fileparts(file_path);
            obj.filename = [obj.filename, '.nc'];
            
            filename_split = split(obj.filename, '.');
            obj.model = filename_split{1};
            
            % Parse year from filename
            yearstr = strrep(filename_split{2}, '-', ' ');
            years = sscanf(yearstr, '%i');
            obj.year = years(1):years(2);
            if obj.year(1) == obj.year(end)
                obj.year = obj.year(1);
            end

            % Store the file pointer
            obj.fileId = netcdf.open(file_path);

            % Pull location information
            obj.lonVec = obj.get('longitude');
            obj.latVec = obj.get('latitude');

            obj.lonVec = obj.get('longitude');
            obj.latVec = obj.get('latitude');

            [obj.latGrid, obj.lonGrid] = meshgrid(obj.latVec, obj.lonVec);
        end
        
        function fields = get.fields(obj)
            % Returns the list of attributes
            fields = netcdf_getnames(obj.fileId);
        end


        function fieldData = get(obj, field)
            % Gets the data for the listed field
            fieldInd = ismember(obj.fields, field);
            if ~any(fieldInd)
                error('Requested field does not exist')
            end
            fieldData = obj.getVar(find(fieldInd)-1);
        end

        function infoStruct = info(obj)
            infoStruct = ncinfo(fullfile(obj.dirname, obj.filename));
        end

    end

    methods (Hidden)
        function var = inqVar(obj, id)
            % Overrides netcdf.inqVar
            var = netcdf.inqVar(obj.fileId, id);
        end
        function var = getVar(obj, id)
            % Overrides netcdf.getVar
            var = netcdf.getVar(obj.fileId, id);
        end
    end

    methods

        function OutStruct = struct(obj)
            % Cast the data to a struct
            OutStruct = netcdf_to_struct(obj.fileId);
        end

        function out = subsref(obj, indstruct)
            % Allows the user to directly reference field names of the data
            % by using the format >> obj.property
            if indstruct(1).type == '.'
                requested_field = indstruct(1).subs;
                if ismember(requested_field, obj.fields)
                    obj = obj.get(requested_field);
                    indstruct(1) = [];
                end
            end

            % After checking for sub-indexing, continue doing any other
            % indexing (e.g. >> obj.property(1:10,:,:)
            if isempty(indstruct)
                out = obj;
            else
                out = builtin('subsref', obj, indstruct);
            end
        end
    end
end

