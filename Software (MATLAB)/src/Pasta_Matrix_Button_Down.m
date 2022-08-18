function Pasta_Matrix_Button_Down(hObject,~)

%
%Pasta_Matrix_Button_Down.m - Vulintus, Inc.
%
%   PASTA_MATRIX_BUTTON_DOWN executes when the user presses a mouse button
%   in the figure axes.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

if gcf ~= hObject                                                           %If the scoring figure doesn't currently has focus...
    return                                                                  %Skip execution of the rest of the function.
end
handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
xy = get(handles.axes,'currentpoint');                                      %Find the xy coordinates of where the user clicked on the GUI.
xy = xy(1,1:2);                                                             %Kick out all but the x- and y-coordinates.
temp = [xlim(handles.axes), ylim(handles.axes)];                            %Grab the x- and y-axes limits.
if xy(1) < temp(1) || xy(1) > temp(2) || xy(2) < temp(3) || xy(2) > temp(4) %If the user clicked outside of the axes...
    return                                                                  %Skip execution of the rest of the function.
end
xy = ceil(xy(1,1:2));                                                       %Round the xy coordinates up to the nearest integer
i = xy(2);                                                                  %Find the horizontal index of the coordinates.
j = xy(1);                                                                  %Find the vertical index of the coordinates.
handles.checked(i,j) = ~handles.checked(i,j);                               %Flip the value of the selected gridpoint.
if handles.checked(i,j) == 1 && ...
        strcmpi(get(handles.fig,'selectiontype'),'alt')                     %If the user checker a box with the right mouse button.
    checker = 1;                                                            %Create a checker variable to control looping.
    pts = [i + 1, j; i - 1, j; i, j + 1; i, j - 1];                         %Set the bounding coordinates to start by checking.
    while checker == 1                                                      %Loop until no more unchecked coordinates are found.
        pts(pts(:,1) <= 0 | pts(:,1) > size(handles.checked,1) | ...
            pts(:,2) <= 0 | pts(:,2) > size(handles.checked,2),:) = [];     %Kick out any invalid points.
        checker = 0;                                                        %Start off assuming no unchecked coordinates will be found.
        for k = 1:size(pts,1)                                               %Step through each pair of coordinates.
            if handles.checked(pts(k,1),pts(k,2)) == 0                      %If a box is unchecked...
                handles.checked(pts(k,1),pts(k,2)) = 1;                     %Check it.
                pts = [pts; pts(k,1) + 1, pts(k,2);...
                    pts(k,1) - 1, pts(k,2);...
                    pts(k,1), pts(k,2) + 1;...
                    pts(k,1), pts(k,2) - 1];                                %Add the bounding coordinates to the list of coordinates to check.
                checker = 1;                                                %Set the checker variable to 1 to loop again.
            end
        end
    end
end
Pasta_Matrix_Draw_Grid(handles);                                            %Draw the grid.
if any(handles.checked(:) == 1)                                             %If there's any checked gridpoints...
    set(handles.clearbutton,'enable','on');                                 %Enable the clear-all button.
else                                                                        %Otherwise...
    set(handles.clearbutton,'enable','off');                                %Disable the clear-all button.
end
guidata(hObject,handles);                                                   %Send the handles structure back to the GUI.