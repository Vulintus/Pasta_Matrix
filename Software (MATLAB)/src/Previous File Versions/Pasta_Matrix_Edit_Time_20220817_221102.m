%% This function executes when the user enters a time in the time editbox.
function Pasta_Matrix_Edit_Time(hObject,~)           

%
%Pasta_Matrix_Edit_Time.m - Vulintus, Inc.
%
%   Pasta_Matrix_Edit_Time executes when the user enters a time in the GUI 
%   session time editbox.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
temp = get(hObject,'string');                                               %Grab the string from the rat name editbox.
try                                                                         %Try to convert the entry to a date number...
    temp(temp < 48 & temp > 57) = [];                                       %Kick out all non-character numbers.
    temp = [temp(1:end-2) ':' temp(end-1:end)];                             %Add back in a colon.
    temp = datenum(temp);                                                   %Grab the date number for the entered text.
    temp = temp - fix(temp);                                                %Subtract the days from the date number to save the time.
    if temp ~= handles.time                                                 %If the new time doesn't match the old...
        handles.time = temp;                                                %Save the new date.
    end
    set(handles.edittime,'string',datestr(handles.time,'HH:MM'));           %Reset the date to the new value.
catch err                                                                   %If the date number failed...
    warning(err.message);                                                   %Show a warning.
    set(handles.edittime,'string',datestr(handles.time,'HH:MM'));           %Reset the time to the previous value.
end
guidata(handles.fig,handles);                                               %Pin the handles structure to the main figure.