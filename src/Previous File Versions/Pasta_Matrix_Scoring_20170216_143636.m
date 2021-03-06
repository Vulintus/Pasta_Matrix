function Pasta_Matrix_Scoring

%% Set the default path for exported files.
temp = getenv('userprofile');                                               %Grab the current user's root directory.
handles.savepath = [temp '\Documents\Pasta Matrix Records\'];               %Create the expected default data path.
if ~exist(handles.savepath,'dir')                                           %If the default data path doesn't yet exist...
    mkdir(handles.savepath);                                                %Create the directory.
end
   
%% Create a matrix to hold the checked/unchecked value.
num_rows = 15;                                                              %Set the number of rows in the grid.
num_columns = 25;                                                           %Set the number of columns in the grid.
handles.checked = zeros(num_rows,num_columns);                              %Create a field to hold the checked/uncheck value of each grid point.
    
%% Create the figure, axes, listboxes, and buttons.
set(0,'units','inches');                                                    %Set the system units to inches.
pos = get(0,'ScreenSize');                                                  %Grab the screensize.
w = 9;                                                                      %Set the figure width, in inches.
h = 8;                                                                      %Set the figure height, in inches.
m = 0.35;                                                                   %Set the margin for the axes, in inches.
pos = [pos(3)/2 - w/2, pos(4)/2 - h/2, w, h];                               %Set the figure position.
handles.fig = figure(1);                                                    %Take control of figure 1 if it exists, create it if it doesn't.
set(handles.fig,'units','inches',...
    'Position',pos,...
    'MenuBar','none',...
    'name','Pasta Matrix Scoring',...
    'numbertitle','off',...
    'PaperPositionMode','auto');                                            %Set the properties of the figure.
handles.clearbutton = uicontrol(handles.fig,'style','pushbutton',...
    'string','CLEAR ALL',...
    'units','inches',...
    'position',[0.1, 0.65, w - 0.2, 0.35],...
    'enable','off',...
    'fontweight','bold',...
    'fontsize',14,...
    'callback',@ClearAll);                                                  %Make a button for clearing all checks.
handles.axes = axes('units','inches',...
    'parent',handles.fig,...
    'position',[m, 0.95 + m, w - 2*m, h - 1.8 - 2*m],...
    'gridlinestyle',':',...
    'xlim',[0, num_columns],...
    'ylim',[0, num_rows],...
    'xdir','reverse',...
    'xtick',0:1:num_columns,...
    'ytick',0:1:num_rows,...
    'box','on',...
    'xgrid','on',...
    'ygrid','on',...
    'xticklabel',[],...
    'yticklabel',[]);                                                       %Create an axes object for plotting the grid.
row_txt = nan(num_rows,2);                                                  %Create a matrix to hold row label text objects.
for i = 1:num_rows                                                          %Step through the rows...
    row_txt(i,1) = text(0,i-0.5,[' ' char(64+i)],...
        'horizontalalignment','left',...
        'verticalalignment','middle',...
        'fontweight','bold',...
        'fontsize',12,...
        'parent',handles.axes);                                             %Create right-hand row labels.
    row_txt(i,2) = text(num_columns,i-0.5,[char(64+i) ' '],...
        'horizontalalignment','right',...
        'verticalalignment','middle',...
        'fontweight','bold',...
        'fontsize',12,...
        'parent',handles.axes);                                             %Create left-hand row labels.
end
column_txt = nan(num_columns,2);                                            %Create a matrix to hold column label text objects.
for i = 1:num_columns                                                       %Step through the rows...
    c = abs(i - ceil(num_columns/2));                                       %Calculate the column number.
    column_txt(i,1) = text(i-0.5,0,num2str(c),...
        'horizontalalignment','center',...
        'verticalalignment','top',...
        'fontweight','bold',...
        'fontsize',12,...
        'parent',handles.axes);                                             %Create right-hand row labels.
    column_txt(i,2) = text(i-0.5,num_rows,num2str(c),...
        'horizontalalignment','center',...
        'verticalalignment','bottom',...
        'fontweight','bold',...
        'fontsize',12,...
        'parent',handles.axes);                                             %Create left-hand row labels.
end
x = 0.15*cos(0:pi/50:2*pi);                                                 %Create x-coordinates for a circle.
y = 0.15*sin(0:pi/50:2*pi);                                                 %Create y-coordinates for a circle.
for j = 1:num_rows                                                          %Step through the rows.
    for i = 1:num_columns                                                   %Step through the columns...
        ln = line(i + x - 0.5, j + y - 0.5,...
            'color',0.7*[1 1 1],...
            'linewidth',2,...
            'userdata',[0,j,i],...
            'parent',handles.axes);                                         %Draw a circle to show each pasta location.
        if rem(j,5) == 0 || rem(i+2,5) == 0                                 %If this row or column is a multiple of five...
            set(ln,'color',0.4*[1 1 1]);                                    %Make the circle slightly darker.
        end
    end
end
uicontrol(handles.fig,'style','edit',...
    'units','inches',...
    'position',[0.1,h - 0.45, 1.10, 0.35],...
    'enable','inactive',...
    'string','SUBJECT:',...
    'horizontalalignment','right',...
    'fontsize',14,...
    'fontweight','bold',...
    'backgroundcolor',[0.7 0.7 1]);                                         %Create a static rat label.
handles.editrat = uicontrol(handles.fig,'style','edit',...
    'units','inches',...
    'position',[1.21,h - 0.45, w/2 - 1.26, 0.35],...
    'string',' ',...
    'horizontalalignment','center',...
    'fontsize',14,...
    'fontweight','bold',...
    'callback',@EditRat);                                                   %Create a rat name editbox.
handles.rat = [];                                                           %Set the rat name to an empty field.
uicontrol(handles.fig,'style','edit',...
    'units','inches',...
    'position',[w/2 + 0.05,h - 0.45, 0.75, 0.35],...
    'enable','inactive',...
    'string','DATE:',...
    'horizontalalignment','right',...
    'fontsize',14,...
    'fontweight','bold',...
    'backgroundcolor',[0.7 0.7 1]);                                         %Create a static date label.
handles.editdate = uicontrol(handles.fig,'style','edit',...
    'units','inches',...
    'position',[w/2 + 0.81,h - 0.45, w/2 - 0.91, 0.35],...
    'string',datestr(now,'mm/dd/yyyy'),...
    'horizontalalignment','center',...
    'fontsize',14,...
    'fontweight','bold',...
    'callback',@EditDate);                                                  %Create a date editbox.
handles.date = fix(now);                                                    %Set the date to the current date.
uicontrol(handles.fig,'style','edit',...
    'units','inches',...
    'position',[0.1,h - 0.85, 1.10, 0.35],...
    'enable','inactive',...
    'string','TIME:',...
    'horizontalalignment','right',...
    'fontsize',14,...
    'fontweight','bold',...
    'backgroundcolor',[0.7 0.7 1]);                                         %Create a static time label.
handles.edittime = uicontrol(handles.fig,'style','edit',...
    'units','inches',...
    'position',[1.21,h - 0.85, w/2 - 1.26, 0.35],...
    'string',datestr(now,'HH:MM'),...
    'horizontalalignment','center',...
    'fontsize',14,...
    'fontweight','bold',...
    'callback',@EditTime);                                                  %Create a time editbox.
handles.time = now - fix(now);                                              %Set the time to the current time.
handles.savebutton = uicontrol(handles.fig,'style','pushbutton',...
    'string','SAVE GRID',...
    'units','inches',...
    'position',[w/2 + 0.05,h - 0.85, w/2 - 0.15, 0.35],...
    'enable','off',...
    'fontweight','bold',...
    'fontsize',14,...
    'callback',@savedata);                                                  %Make a button for saving the data.
p = uipanel('parent',handles.fig,...
    'units','inches',...
    'position',[0.1, 0.1, w - 0.2, 0.45]);                                  %Create a panel to house the analysis buttons.
uicontrol(p,'style','edit',...
    'string','Analysis:',...
    'units','normalized',...
    'position',[0.01, 0.111, 0.12, 0.7778],...
    'fontweight','bold',...
    'enable','inactive',...
    'backgroundcolor',[0.7 1 0.7],...
    'fontsize',14);                                                         %Make a button for esporting population data to a TSV file.
uicontrol(p,'style','pushbutton',...
    'string','Population Data to TSV',...
    'units','normalized',...
    'position',[0.14, 0.111, 0.42, 0.7778],...
    'enable','on',...
    'fontweight','bold',...
    'fontsize',14,...
    'callback',{@Pasta_PopData_to_TSV,handles.savepath});                   %Make a button for esporting population data to a TSV file.
uicontrol(p,'style','pushbutton',...
    'string','Timeline Plots',...
    'units','normalized',...
    'position',[0.57, 0.111, 0.42, 0.7778],...
    'enable','off',...
    'fontweight','bold',...
    'fontsize',14);                                                         %Make a button for esporting population data to a TSV file.
guidata(handles.fig,handles);                                               %Pin the handles structure to the GUI.
set(handles.fig,'WindowButtonDownFcn',@ButtonDown,...
    'WindowButtonMotionFcn',{@MouseHover,handles.axes,row_txt,column_txt}); %Set the window button down and button motion function.


%% This function executes when the user enters a rat's name in the editbox
function EditRat(hObject,~)           
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


%% This function executes when the user enters a date in the date editbox.
function EditDate(hObject,~)           
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


%% This function executes when the user enters a time in the time editbox.
function EditTime(hObject,~)           
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


%% This function executes when the user presses a mouse button in the figure axes.
function ButtonDown(hObject,~)
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
DrawGrid(handles);                                                          %Draw the grid.
if any(handles.checked(:) == 1)                                             %If there's any checked gridpoints...
    set(handles.clearbutton,'enable','on');                                 %Enable the clear-all button.
else                                                                        %Otherwise...
    set(handles.clearbutton,'enable','off');                                %Disable the clear-all button.
end
guidata(hObject,handles);                                                   %Send the handles structure back to the GUI.


%% This function executes while the mouse hovers over the axes.
function MouseHover(hObject,~,ax,row_txt,column_txt)
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


%% This function is called when the user presses the "Clear All" button.
function ClearAll(hObject,~)
handles = guidata(hObject);                                                 %Grab the handles structure from the GUI.
handles.checked(:) = 0;                                                     %Set all gridpoints to be unchecked.
DrawGrid(handles);                                                          %Draw the grid.
set(handles.clearbutton,'enable','off');                                    %Disable the clear-all button.
guidata(hObject,handles);                                                   %Send the handles structure back to the GUI.


%% This function draws the motor map in the figure's axes.
function DrawGrid(handles)
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


%% This function executes when the user hits the "Save Data" Button.
function savedata(hObject,~)
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