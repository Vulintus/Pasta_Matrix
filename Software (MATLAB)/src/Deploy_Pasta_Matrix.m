function Deploy_Pasta_Matrix

%
%Deploy_Pasta_Matrix.m - Vulintus, Inc.
%
%   DEPLOY_PASTA_MATRIX collates all of the *.m file dependencies for the 
%   pasta matrix scoring and analysis program into a single *.m file and 
%   creates time-stamped back-up copies of each file when a file 
%   modification is detected.
%
%   UPDATE LOG:
%   02/16/2017 - Drew Sloan - Function first created.
%   08/17/2022 - Drew Sloan - Updated to remove FTP uploading, switching
%       over to a public Github repository.
%

start_script = 'Pasta_Matrix_Startup.m';                                    %Set the expected name of the initialization script.
collated_filename = 'Pasta_Matrix.m';                                       %Set the name for the collated script.

[collated_file, ~] = Vulintus_Collate_Functions(start_script,...
    collated_filename,'depfunfolder','on');                                 %Call the generalized function-collating script.

[release_path, file, ext] = fileparts(collated_file);                       %Grab the path from the collated filename.

[mainpath, cur_dir, ~] = fileparts(release_path);                           %Strip out the filename from the path to the collated file.
while ~strcmpi(cur_dir,'Software (MATLAB)') && ~isempty(cur_dir)            %Loop until we get to the "Software (MATLAB)" folder.
    [mainpath, cur_dir, ~] = fileparts(mainpath);                           %Strip out the filename from the path.
end
mainpath = fullfile(mainpath,'Software (MATLAB)');                          %Add the MATLAB Scripts directory back to the path.

copyfile(collated_file, mainpath, 'f');                                     %Copy the collated file to the main path.

file = [file '_' datestr(now, 'yyyymmdd_HHMMSS') ext];                      %Create a timestamped filename.
file = fullfile(release_path, file);                                        %Add the path back to the file.
copyfile(collated_file, file, 'f');                                         %Create a timestamped copy of the collated file.
delete(collated_file);                                                      %Delete the original collated file.