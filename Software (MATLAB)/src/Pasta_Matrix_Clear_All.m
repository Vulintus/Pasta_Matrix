function Pasta_Matrix_Clear_All(hObject,~)

%
%Pasta_Matrix_Clear_All.m - Vulintus, Inc.
%
%   PASTA_MATRIX_CLEAR_ALL is called when the user presses the "Clear All" 
%   button.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
handles.checked(:) = 0;                                                     %Set all gridpoints to be unchecked.
Pasta_Matrix_Draw_Grid(handles);                                            %Draw the grid.
set(handles.clearbutton,'enable','off');                                    %Disable the clear-all button.
guidata(hObject,handles);                                                   %Send the handles structure back to the GUI.