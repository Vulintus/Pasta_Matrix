function Pasta_Matrix_Draw_Grid(handles)

%
%Pasta_Matrix_Draw_Grid.m - Vulintus, Inc.
%
%   PASTA_MATRIX_DRAW_GRID draws the motor map in the figure's axes.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

objs = get(handles.axes,'children');                                        %Grab all children of the main axes.
objs(~strcmpi(get(objs,'type'),'line')) = [];                               %Kick out all objects that aren't line objects.
temp = get(objs,'userdata');                                                %Grab all the userdata from the line properties.
temp = vertcat(temp{:});                                                    %Concatenate all of the userdata into a matrix.
objs(temp(:,1) == 0) = [];                                                  %Kick out all pasta circles.
temp(temp(:,1) == 0,:) = [];                                                %Kick out all pasta circles from the userdata matrix.
for i = 1:size(handles.checked,1)                                           %Step through each row of the checked matrix.
    for j = 1:size(handles.checked,2)                                       %Step through each column of the checked matrix.
        if handles.checked(i,j) == 1 && ...
                (isempty(temp) || ~any(temp(:,2) == i & temp(:,3) == j))   %If the box should be checked, but isn't...
            line(j - [0.8,0.2], i - [0.8,0.2],'color',[0.5 0 0],...
                'linewidth',2,'parent',handles.axes,'userdata',[1 i j]);    %Draw a downward diagonal across the gridpoint.
            line(j - [0.2,0.8], i - [0.8,0.2],'color',[0.5 0 0],...
                'linewidth',2,'parent',handles.axes,'userdata',[1 i j]);    %Draw an upward diagonal across the gridpoint.
        elseif ~isempty(temp) && handles.checked(i,j) == 0 && ...
                any(temp(:,2) == i & temp(:,3) == j)                        %If the box shouldn't be checked, but is...
            delete(objs(temp(:,2) == i & temp(:,3) == j));                  %Delete the diagonal lines for this gridpoint.
        end
    end
end