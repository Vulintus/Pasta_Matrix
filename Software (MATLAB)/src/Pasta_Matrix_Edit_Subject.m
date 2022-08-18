function Pasta_Matrix_Edit_Subject(hObject,~)           

%
%Pasta_Matrix_Edit_Subject.m - Vulintus, Inc.
%
%   PASTA_MATRIX_EDIT_SUBJECT executes when the user enters a subject's 
%   name in the GUI subject name editbox.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
temp = get(hObject,'string');                                               %Grab the string from the rat name editbox.
for c = '/\?%*:|"<>. '                                                      %Step through all reserved characters.
    temp(temp == c) = [];                                                   %Kick out any reserved characters from the rat name.
end
if ~strcmpi(temp,handles.rat)                                               %If the rat's name was changed.
    handles.rat = upper(temp);                                              %Save the new rat name in the handles structure.
    guidata(handles.fig,handles);                                           %Pin the handles structure to the main figure.
end
set(handles.editrat,'string',handles.rat);                                  %Reset the rat name in the rat name editbox.
if ~isempty(handles.rat)                                                    %If the user has set a rat name...
    set(handles.savebutton,'enable','on');                                  %Enable the save button.
else                                                                        %Otherwise...
    set(handles.savebutton,'enable','off');                                 %Disable the save button.
end
guidata(handles.fig,handles);                                               %Pin the handles structure to the main figure.
