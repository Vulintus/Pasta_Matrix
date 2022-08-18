function Pasta_Matrix_Mouse_Hover(hObject,~,ax,row_txt,column_txt)

%
%Pasta_Matrix_Mouse_Hover.m - Vulintus, Inc.
%
%   PASTA_MATRIX_MOUSE_HOVER executes while the mouse hovers over the axes.
%   
%   UPDATE LOG:
%   08/17/2022 - Drew Sloan - Subfunctions separated out from 
%       Pasta_Matrix.m
%

if gcf ~= hObject                                                           %If the scoring figure doesn't currently has focus...
    return                                                                  %Skip execution of the rest of the function.
end
xy = get(ax,'CurrentPoint');                                                %Grab the current mouse position in the axes.
xy = xy(1,1:2);                                                             %Pare down the x-y coordinates matrix.
a = [xlim, ylim];                                                           %Grab the x- and y-axis limits.
set(row_txt(:),'color','k','fontsize',12);                                  %Make all row labels black.
set(column_txt(:),'color','k','fontsize',12);                               %Make all column labels black.
if xy(1) > a(1) && xy(1) < a(2) && xy(2) > a(3) && xy(2) < a(4)             %If the mouse is hovering inside the axes...
    xy = ceil(xy);                                                          %Round the xy coordinates up to the nearest integer
    i = xy(2);                                                              %Find the horizontal index of the coordinates.
    j = xy(1);                                                              %Find the vertical index of the coordinates.
    set([row_txt(i,:), column_txt(j,:)],'color','r','fontsize',14);         %Make the current row and column labels red.
end
drawnow;                                                                    %Update the plots immediately.