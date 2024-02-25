% This opens the files in the example and loads them into the workspace.
% These must be on your path, so init_path is called here _just in case_

init_path;

% Load the files (these are on the path, so I just need their name)
ModernSST_2024 = NC_File('Modern_PredictedSST.2024-2024ij');
Doubled_2024 = NC_File('Doubled_CO2.2024-2024ij');

% I can get the data as a struct by casting or I can use it as the file obj
% The annual data is the last page of data ('end' entry in dim 3)
ModernSST_surf_air_temp = ModernSST_2024.SurfAirTemp(:,:,end);
Doubled_surf_air_temp = Doubled_2024.SurfAirTemp(:,:,end);

figure;
worldmap('world')
hold on;
pcolorm(ModernSST_2024.latGrid, ...
        ModernSST_2024.lonGrid, ...
        ModernSST_surf_air_temp);
title('ModernSST Surface Air Temperature')
add_deg_c_colorbar();


figure;
worldmap('world')
hold on;
pcolorm(ModernSST_2024.latGrid, ...
        ModernSST_2024.lonGrid, ...
        Doubled_surf_air_temp);
title('DoubledCO2 Surface Air Temperature')
add_deg_c_colorbar();


figure;
worldmap('world')
hold on;
pcolorm(ModernSST_2024.latGrid, ...
        ModernSST_2024.lonGrid, ...
        Doubled_surf_air_temp - ModernSST_surf_air_temp);
title({'Difference in Annual average temperature','(DoubledCO2 - ModernSST)'})
add_deg_c_colorbar();



function add_deg_c_colorbar()

cbar = colorbar();
title(cbar, 'Degrees C');

end

