function Pasta_Matrix_Save_Data(hObject,~)

%
%Pasta_Matrix_Save_Data.m - Vulintus, Inc.
%
%   PASTA_MATRIX_SAVE_DATA executes when the user hits the "Save Data" 
%   button.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
timestamp = handles.date + handles.time;                                    %Add the date and time together to create a timestamp.
filename = ['PASTA_MATRIX_' handles.rat '_' ...
    datestr(timestamp,'yyyymmdd_HHMM') '.png'];                             %Create a filename for the data.
[file, path] = uiputfile('*.png','Save Pasta Matrix Data',...
    [handles.savepath '\' filename]);                                       %Ask the user for a filename.
if file(1) == 0                                                             %If the user clicked "cancel"...
    return                                                                  %Skip execution of the rest of the function.
end
str = sprintf('SUBJECT: %s; TIMESTAMP: %1.8f',handles.rat,timestamp);       %Create a comment holding the subject name and timestamp.
imwrite(handles.checked,[path file],'png','comment',str);                   %Write the data to file as a PNG image.