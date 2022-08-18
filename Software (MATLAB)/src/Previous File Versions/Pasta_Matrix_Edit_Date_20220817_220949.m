function Pasta_Matrix_Edit_Date(hObject,~)           

%
%Pasta_Matrix_Edit_Date.m - Vulintus, Inc.
%
%   PASTA_MATRIX_EDIT_DATE executes when the user enters a date in the
%   GUI date editbox.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
temp = get(hObject,'string');                                               %Grab the string from the rat name editbox.
try                                                                         %Try to convert the entry to a date number...
    temp = fix(datenum(temp));                                              %Grab the date number for the entered text.
    if temp ~= handles.date                                                 %If the new date doesn't match the old...
        handles.date = temp;                                                %Save the new date.
    end
    set(handles.editdate,'string',datestr(handles.date,'mm/dd/yyyy'));      %Reset the date to the new value.
catch err                                                                   %If the date number failed...
    warning(err.message);                                                   %Show a warning.
    set(handles.editdate,'string',datestr(handles.date,'mm/dd/yyyy'));      %Reset the date to the previous value.
end

guidata(handles.fig,handles);                                               %Pin the handles structure to the main figure.