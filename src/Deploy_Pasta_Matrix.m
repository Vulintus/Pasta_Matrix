function Deploy_Pasta_Matrix

%
%Deploy_Pasta_Matrix.m - Vulintus, Inc.
%
%   Deploy_Pasta_Matrix collates all of the *.m file dependencies
%   for the pasta matrix scoring and analysis program into a single *.m 
%   file and creates time-stamped back-up copies of each file when a file 
%   modification is detected. It will then bundle the executable with 
%   associated deployment files and will automatically upload that zip file
%   to the Vulintus download page.
%
%   UPDATE LOG:
%   02/16/2017 - Drew Sloan - Function first created.

cur_ver = 1.00;                                                             %Specify the current program version.

start_script = 'Pasta_Matrix.m';                                            %Set the expected name of the initialization script.
ver_str = num2str(cur_ver,'v%1.2f');                                        %Convert the version number to a string.
ver_str(ver_str == '.') = 'p';                                              %Replace the period in the version string with a lower-case "p".
collated_filename = sprintf('Pasta_Matrix_%s.m',ver_str);                   %Set the name for the collated script.
update_url = ['https://docs.google.com/document/d/1lI6HnhtpfHmMHgXMfY0C'...
    'p1EdhjPN8V4Ex_2pBPit3Po/pub'];                                         %Specify the URL where program updates will be described.
web_file = 'Pasta_Matrix_updates.html';                                     %Specify the name of the updates HTML page.

[collated_file, zip_file] = ...
    Vulintus_Collate_Functions(start_script, collated_filename);            %Call the generalized function-collating script.

Vulintus_Upload_File(collated_file, 'public_html/downloads/');              %Upload the collated file to the Vulintus downloads page.
Vulintus_Upload_File(zip_file, 'public_html/downloads/');                   %Upload the zipped functions file to the Vulintus downloads page.

installer_dir = which(start_script);                                        %Grab the full path of the initialization script.
installer_dir(end-length(start_script)+1:end) = [];                         %Kick out the filename from the full path.
installer_dir = [installer_dir 'Web Installer\'];                           %Set the expected name of the web installer folder.
compile_time = 'na';                                                        %Assume the web installer compile time can't be determined by default.
if exist(installer_dir,'dir')                                               %If the web installer directory exists...
    file = [installer_dir 'Pasta_Matrix_' ver_str '_win64.exe'];            %Set the expected file name of the web isntaller.
    if exist(file,'file')                                                   %If the web installer exists...
        Vulintus_Upload_File(file, 'public_html/downloads/');               %Upload the MotoTrak Analysis Web Installer to the Vulintus downloads page.
        info = dir(file);                                                   %Grab the file information.
        compile_time = info.date;                                           %Grab the last modified date for the web installer.
    else                                                                    %Otherwise...
        warning(['WARNING: Could not find the Pasta Matrix Scoring Web '...
            'Installer executable.']);                                      %Show a warning.
    end
else                                                                        %Otherwise...
    warning(['WARNING: Could not find the Pasta Matrix Scoring Web '...
        'Installer directory.']);                                           %Show a warning.
end

web_file = [tempdir web_file];                                              %Create the updates HTML file in the temporary folder.
fid = fopen(web_file,'wt');                                                 %Open the updates HTML file for writing as text.
fprintf(fid,'<HTML><p>MOTOTRAK ANALYSIS</p><p>CURRENT VERSION: ');          %Write the HTML start tag to the file.
fprintf(fid,'%1.2f</p><p>COMPILE TIME: ',cur_ver);                          %Write the the current program version to the file.
fprintf(fid,'%s</p><p>UPDATE URL: ',compile_time);                          %Write the the installer compile time to the file.
fprintf(fid,'%s</p></HTML>',update_url);                                    %Write the the update URL to the file.
fclose(fid);                                                                %Close the HTML file.
Vulintus_Upload_File(web_file, 'public_html/updates/');                     %Upload the updates HTML file to the Vulintus updates page.
delete(web_file);                                                           %Delete the temporary HTML file.