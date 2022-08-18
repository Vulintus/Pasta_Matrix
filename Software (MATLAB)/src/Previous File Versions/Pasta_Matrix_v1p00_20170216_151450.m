function Pasta_Matrix_v1p00

%Compiled: 02/16/2017, 15:14:50

Pasta_Matrix;                                                              %Call the startup function.


function Pasta_Matrix

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


function Pasta_Matrix

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


function Pasta_PopData_to_TSV(varargin)
%
%PASTA_POPDATA_TO_TSV.m - Vulintus, Inc., 2016.
%
%   PASTA_POPDATA_TO_TSV reads data from batches of pasta matrix records,
%   in  the form of *.JPG files, computes user-selected task parameters, 
%   and then outputs the values into an Excel-readable TSV (tab-separated
%   values) spreadsheet, with each line corresponding to one behavioral 
%   session.
%
%   UPDATE LOG:
%   02/16/2017 - Drew Sloan - Function first created.
%

fields = [];                                                                %Create a structure to hold all possible output fields.                 
fields.mandatory = {    'DATE (DD/MM/YYYY)';
                        'TIME (HH:MM)';
                        'SUBJECT';
                        'BROKEN COUNT'};                                    %List the mandatory columns that will be displayed in every TSV file.
                    
fields.optional =   {   'FARTHEST REACH (mm)';
                        'REACH CENTROID DISTANCE (mm)';
                        'REACH CENTROID X-COORDINATE (mm)';
                        'REACH CENTROID Y-COORDINATE (mm)'};                %List the optional columns that apply to every task type.

                    
%Set the expected path for the configuration file.
configpath = Vulintus_Set_AppData_Path('Pasta Matrix Analysis');            %Use the Pasta Matrix Analysis AppData folder for configuration files.


%Have the user choose a path containing data files to analyze.
if nargin > 0                                                               %If there's more than one optional input argument.
    datapath = varargin{end};                                               %Assume the last input is the default data path.
else                                                                        %Otherwise, if no default data path was passed to the function...
    temp = getenv('userprofile');                                           %Grab the current user's root directory.
    datapath = [temp '\Documents\Pasta Matrix Records\'];                   %Create the expected default data path.
end
if ~exist(datapath,'dir')                                                   %If the primary local data path doesn't exist...
    datapath = pwd;                                                         %Set the default path to the current directory.
end
datapath = uigetdir(datapath,'Where is your pasta matrix data located?');   %Ask the user where their data is located.
if datapath(1) == 0                                                         %If the user pressed "cancel"...
    return                                                                  %Skip execution of the rest of the function.
end


%Find all of the MotoTrak data files in the data path.
files = file_miner(datapath,'*.png');                                       %Find all PNG files in the selected
pause(0.01);                                                                %Pause for 10 milliseconds.
if isempty(files)                                                           %If no files were found...
    errordlg('No PNG image files were found in the that directory!');       %Show an error dialog box.
end


%Step through all of the data files and load them into a structure.
waitbar = big_waitbar('title','Loading Pasta Matrix Files...');             %Create a waitbar figure.
data = [];                                                                  %Create a structure to receive data.
for f = 1:length(files)                                                     %Step through the data files.
    [~,filename,ext] = fileparts(files{f});                                 %Grab the filename and extension from the trial.
    if waitbar.isclosed()                                                   %If the user closed the waitbar figure...
        errordlg(['The pasta matrix export population data to TSV file '...
            'was cancelled by the user!'],'Export Cancelled');               %Show an error.
        return                                                              %Skip execution of the rest of the function.
    else                                                                    %Otherwise...
        waitbar.string(sprintf('Loading (%1.0f/%1.0f): %s%s',...
            f, length(files), filename, ext));                              %Update the waitbar text.
        waitbar.value(f/length(files));                                     %Update the waitbar value.
    end
    info = imfinfo(files{f});                                               %Grab the image information from the file.
    if info.Width ~= 25 || info.Height ~= 15 || ...
            ~isfield(info,'Comment') || isempty(info.Comment)               %If the image information doesn't match that of a pasta matrix record image...
    	continue                                                            %Skip to the next file.
    end
    str = info.Comment;                                                     %Grab the comment field from the image information.
    if ~strncmpi(str,'SUBJECT: ',9) || length(str) < 37                     %If the first 8 characters of the comment aren't "SUBJECT:"...
        continue                                                            %Skip to the next file.
    end
    s = length(data) + 1;                                                   %Create a new field index.
    data(s).subject = str(10:end-28);                                       %Grab the subject name from the comment.
    data(s).timestamp = str2double(str(end-14:end));                        %Grab the timestamp from the end of the comment.
    map = imread(files{f});                                                 %Read in the image file.
    map = double(map/255);                                                  %Convert the pixel values to binary values.
    data(s).map = map;                                                      %Save the map to the structure.
    data(s).count = sum(map(:) == 1);                                       %Grab the total pasta count for that session.
    data(s).file = [filename, ext];                                         %Save the filename with the extension.
end
waitbar.close();                                                            %Close the waitbar.
if isempty(data)                                                            %If no data files were found...
    errordlg(['There were no valid pasta matrix data files found in '...
        'the specified directory!']);                                       %Show an error dialog box.
end
[~,i] = sort([data.timestamp]);                                             %Find the indices to sort all files chronologically.
data = data(i);                                                             %Sort all files chronologically.


%Have the user select subjects to include or exclude in the analysis.
subject_list = unique({data.subject});                                      %Make a list of all the unique rat names.
i = listdlg('PromptString','Which subjects would you like to include?',...
    'name','MotoTrak Analysis',...
    'SelectionMode','multiple',...
    'listsize',[300 400],...
    'initialvalue',1:length(subject_list),...
    'uh',25,...
    'ListString',subject_list);                                             %Have the user pick subjects to include.
if isempty(i)                                                               %If the user clicked "cancel" or closed the dialog...
    return                                                                  %Skip execution of the rest of the function.
else                                                                        %Otherwise...
    subject_list = subject_list(i);                                         %Pare down the rat list to those that the user selected.
end
keepers = ones(length(data),1);                                             %Create a matrix to check which files match the selected rat names.
for i = 1:length(data)                                                      %Step through each data file.
    if ~any(strcmpi(subject_list,data(i).subject))                          %If this file's rat name wasn't selected...
        keepers(i) = 0;                                                     %Mark the file for exclusion.
    end
end
data(keepers == 0) = [];                                                    %Kick out all files the user doesn't want to include.


%Load any existing configuration file.
all_fields = vertcat(fields.mandatory, fields.optional);                    %Create a list of all available fields.
output = [];                                                                %Create a cell array to hold the optional output fields.
filename = fullfile(configpath, 'pasta_popdata_tsv.config');                %Create the expected configuration filename.
if exist(filename,'file')                                                   %If a configuration file already exists...
    fid = fopen(filename,'rt');                                             %Open the configuration file for reading.
    txt = fread(fid,'*char');                                               %Read in the data as characters.
    fclose(fid);                                                            %Close the configuration file.
    a = [0; find(txt == 10); length(txt) + 1];                              %Find all carriage returns in the text data.        
    for j = 1:length(a) - 1                                                 %Step through all lines in the data.
        ln = txt(a(j)+1:a(j+1)-1)';                                         %Grab the line of text.
        ln(ln == 0) = [];                                                   %Kick out all null characters.
        if ~isempty(ln)                                                     %If the area any non-null characters in the line...
            output{j,1} = ln;                                               %Each line will be a field name.
        end
    end
    keepers = ones(size(output));                                           %Create a matrix to check each saved field for a match.
    for i = 1:length(output)                                                %Step through each saved field.
        if ~any(strcmpi(output{i},all_fields))                              %If the saved field name doesn't match any recognized field...
            keepers(i) = 0;                                                 %Mark the saved field for exclusion.
        end
    end
    output(keepers == 0) = [];                                              %Only keep the recognized fields.
else                                                                        %Otherwise...
    output = fields.mandatory;                                              %Pre-populate the output with only the mandatory fields.
end


%Have the user select which fields they'd like printed to the TSV files.
selected_fields = output;                                                   %Grab the currently-selected fields.
fig = Selection_GUI(selected_fields,fields.mandatory,all_fields);           %Call the subfunction to create the selection GUI.
uiwait(fig);                                                                %Wait for the user to make a selection.
if ishandle(fig)                                                            %If the user didn't close the figure without choosing a port...
    objs = get(fig,'children');                                             %Grab all children of the figure.
    j = strcmpi(get(objs,'style'),'popupmenu');                             %Find all pop-up menu objects.
    objs(j == 0) = [];                                                      %Kick out all non-pop-up objects.
    str = get(objs(1),'string');                                            %Grab the string from the first object.
    j = cell2mat(vertcat(get(objs,'userdata')));                            %Grab the UserData property of all pop-up menu objects.
    k = cell2mat(vertcat(get(objs,'value')));                               %Grab the value of all pop-up menu objects.
    selected_fields = str(k(j));                                            %Grab the list of selected columns.        
    delete(fig);                                                            %Close the figure.
else                                                                        %Otherwise, if the user closed the figure without choosing a port...
    delete(fig);                                                            %Close the figure.
    return                                                                  %Skip execution of the rest of the function.
end
filename = fullfile(configpath, ['pasta_popdata_tsv.config']);              %Create the expected configuration filename.
fid = fopen(filename,'wt');                                                 %Open the configuration file for writing.
for j = 1:length(selected_fields)                                           %Step through each selected field.
    fprintf(fid,'%s\n',selected_fields{j});                                 %Print each column name to the configuration file.
end
fclose(fid);                                                                %Close the configuration file.
output = selected_fields;                                                   %Save the selected fields to the structure.


%Create individual spreadsheets for each of the device types.
path = [getenv('USERPROFILE') '\'];                                         %Use the user profile root documents folder as the default path.
clc;                                                                        %Clear the command window.
filename = upper('Pasta_Matrix_Session_Data');                              %Create a default file name.
[filename, path] = uiputfile('*.tsv','Save Pasta Matrix Spreadsheet',...
    [path filename]);                                                       %Ask the user for a filename.
if filename(1) == 0                                                         %If the user clicked cancel...        
    fclose all;                                                             %Close all open binary files.
    for f = 1:(d-1)                                                         %Step through any preceding device's files...            
        delete(files{f});                                                   %Delete the files.
    end
    errordlg(['The pasta matrix export to TSV file was cancelled by '...
        'the user!'],'Export Cancelled');                                   %Show an error.
    return                                                                  %Skip execution of the rest of the function.
end
filename = [path filename];                                                 %Save the filename with the specified path.
fid = fopen(filename,'wt');                                                 %Open a new text file to write the data to.    
if fid == -1                                                                %If the file couldn't be opened...
    fclose(fid);                                                            %Close the file.
    delete(filename);                                                       %Delete the output file.
    errordlg(['Could not create the specified file! Make sure the '...
        'file isn''t currently open and retry.'],'File Write Error');       %Show an error.
    return                                                                  %Skip execution of the rest of the function.
end
N = length(output);                                                         %Grab the total number of output columns.
for i = 1:length(output)                                                    %Step through all of the output columns.
    fprintf(fid,'%s',output{i});                                            %Print each column heading.
    if i < N                                                                %If this isn't the last column...
        fprintf(fid,'\t');                                                  %Print a tab separator.
    else                                                                    %Otherwise, if this is the last column...
        fprintf(fid,'\n');                                                  %Print a carriage return.
    end
end
waitbar = big_waitbar;                                                      %Create a waitbar figure.
waitbar.title('Exporting Pasta Matrix Data...');                            %Change the title on the waitbar...
N = length(data);                                                           %Keep track of the total number of sessions.
counter = 0;                                                                %Create a counter to count through the files.
subjects = unique({data.subject});                                          %Find all of the unique rat names.
dist_x = 4*ones(15,1)*[-12:12];                                             %Calculate the x-axis distance to each pasta strand.
dist_y = 4*(1:15)'*ones(1,25) + 4;                                       %Calculate the y-axis distance to each pasta strand.
dist = sqrt(dist_x.^2 + dist_y.^2);                                         %Calculate the straight-line distance to each pasta strand.
for r = 1:length(subjects)                                                  %Step through each rat.
    i = find(strcmpi({data.subject},subjects{r}));                          %Find all the session for this rat.
    for s = i                                                               %Step through each session.
        counter = counter + 1;                                              %Increment the session counter.
        if waitbar.isclosed()                                               %If the user closed the waitbar figure...
            fclose all;                                                     %Close all open output files.
            delete(files{d});                                               %Delete the current file.
            errordlg(['The pasta matrix export to TSV file was '...
                'cancelled by the user!'],'Export Cancelled');              %Show an error.
            return                                                          %Skip execution of the rest of the function.
        else                                                                %Otherwise...
            waitbar.string([sprintf('Exporting (%1.0f/%1.0f): ',...
                [counter,N]) data(s).file]);                                %Update the waitbar text.
            waitbar.value(counter/N);                                       %Update the waitbar value.
        end
        for j = 1:length(output)                                            %Step through all of the output columns.                     
            switch output{j}                                                %Switch between the possible column values.
                case 'BROKEN COUNT'
                    fprintf(fid,'%1.0f',data(s).count);                     %Print the broken pasta count.
                case 'DATE (DD/MM/YYYY)'
                    fprintf(fid,'%s',...
                        datestr(data(s).timestamp,'mm/dd/yyyy'));           %Print the date.
                case 'FARTHEST REACH (mm)'
                    temp = dist(data(s).map == 1);                          %Find the straight-line distance to all broken pasta strands.                    
                    fprintf(fid,'%1.3f',max(temp));                         %Print the maximum reach distance.
                case 'REACH CENTROID DISTANCE (mm)'
                    x = mean(dist_x(data(s).map == 1));                     %Find the x-axis distance to all broken pasta strands.
                    y = mean(dist_y(data(s).map == 1));                     %Find the y-axis distance to all broken pasta strands.    
                    fprintf(fid,'%1.3f',sqrt(x^2 + y^2));                   %Print the reach centroid distance.
                case 'REACH CENTROID X-COORDINATE (mm)'
                    x = mean(dist_x(data(s).map == 1));                     %Find the x-axis distance to all broken pasta strands. 
                    fprintf(fid,'%1.3f',x);                                 %Print the reach centroid x-axis distance.
                case 'REACH CENTROID Y-COORDINATE (mm)'
                    y = mean(dist_y(data(s).map == 1));                     %Find the y-axis distance to all broken pasta strands.    
                    fprintf(fid,'%1.3f',y);                                 %Print the reach centroid y-axis distance.
                case 'TIME (HH:MM)'
                    fprintf(fid,'%s',datestr(data(s).timestamp,'HH:MM'));   %Print the time of day.
                case 'SUBJECT'
                    fprintf(fid,'%s',data(s).subject);                      %Print the subject name.
            end
            if j < length(output)                                           %If this isn't the last column...
                fprintf(fid,'\t');                                          %Print a tab separator.
            else                                                            %Otherwise, if this is the last column...
                fprintf(fid,'\n');                                          %Print a carriage return.
            end
        end
    end
end    
fclose(fid);                                                                %Close tje open file.
winopen(filename);                                                          %Open the TSV file.
waitbar.close();                                                            %Close the waitbar.


%% This subfunction creates the GUI for selecting output columns.
function fig = Selection_GUI(selected_fields,mandatory_fields,all_fields)
uih = 0.75;                                                                 %Set the height for all dropdown menus.
w = 20;                                                                     %Set the width of the field selection figure.
sp = 0.05;                                                                  %Set the space between elements, in centimeters.
N = length(selected_fields);                                                %Grab the number of currently-selected fields.
h = (N + 2.5)*(uih + sp) + sp;                                              %Set the height of the function selection figure.
set(0,'units','centimeters');                                               %Set the screensize units to centimeters.
pos = get(0,'ScreenSize');                                                  %Grab the screensize.
pos = [pos(3)/2-w/2, pos(4)/2-h/2, w, h];                                   %Scale a figure position relative to the screensize.
fig = figure('units','centimeters',...
    'Position',pos,...
    'resize','off',...
    'MenuBar','none',...
    'name','Select Output Columns for Pasta Matrix Data',...
    'numbertitle','off',...
    'closerequestfcn','uiresume(gcbf);');                                   %Set the properties of the figure.
uicontrol(fig,'style','edit',...
        'string','Pasta Matrix Data Output Columns:',...
        'units','centimeters',...
        'position',[sp h-1.5*(uih+sp) w-2*sp 1.5*uih],...
        'fontweight','bold',...
        'fontsize',16,...
        'horizontalalignment','left',...
        'userdata',0,...
        'backgroundcolor',[0.7 0.7 0.7],...
        'enable','inactive');                                               %Create a label at the top.
for j = 1:size(selected_fields,1)                                           %Step through each currently-selected field.
    uicontrol(fig,'style','edit',...
        'string',num2str(j),...
        'units','centimeters',...
        'position',[sp h-(j+1.5)*(uih+sp) uih uih],...
        'fontsize',12,...
        'fontweight','bold',...
        'foregroundcolor','k',...
        'enable','inactive',...
        'userdata',j);                                                      %Create text for labeling the column number.
    btn = uicontrol(fig,'style','pushbutton',...
        'string','X',...
        'units','centimeters',...
        'position',[2*sp+uih h-(j+1.5)*(uih+sp) uih uih],...
        'fontsize',12,...
        'fontweight','bold',...
        'foregroundcolor',[0.5 0 0],...
        'userdata',j,...
        'callback',@Delete_Menu);                                           %Create a button for deleting the column.
    pop = uicontrol(fig,'style','popupmenu',...
        'string',all_fields,...
        'value',find(strcmpi(selected_fields{j},all_fields)),...
        'units','centimeters',...
        'position',[3*sp+2*uih h-(j+1.5)*(uih+sp) w-4*sp-2*uih uih],...
        'userdata',j,...
        'fontsize',12);                                                     %Make a pop-up menu for each field.
    if any(strcmpi(all_fields{j},mandatory_fields))                         %If this field is mandatory...
        set(btn,'string','-',...
            'foregroundcolor','k',...
            'enable','inactive');                                           %Disable the delete menu button.
        set(pop,'enable','inactive');                                       %Disable the popup menu.
    end    
end
obj = uicontrol(fig,'style','pushbutton',...
    'string','+',...
    'units','centimeters',...
    'position',[2*sp+uih h-(j+2.5)*(uih+sp) uih uih],...
    'fontsize',12,...
    'fontweight','bold',...
    'foregroundcolor','k',...
    'callback',@Create_Menu);                                               %Create a button for adding a new column.
if isempty(setdiff(all_fields,selected_fields))                             %If all fields are selected...
    set(obj,'enable','off');                                                %Disable the "add column" button.
end
uicontrol(fig,'style','pushbutton',...
    'string','Set Outputs',...
    'units','centimeters',...
    'position',[3*sp+2*uih sp w-4*sp-2*uih uih],...
    'fontsize',12,...
    'fontweight','bold',...
    'callback','uiresume(gcbf);');                                          %Create a button for finalizing the column outputs.


%% This subfunction is called when the user presses the button to add a column.
function Create_Menu(hObject,~)
pos = get(hObject,'position');                                              %Grab the calling pushbutton's position.
fig = gcbf;                                                                 %Grab the parent figure handle.
uih = pos(4);                                                               %Match the height for all dropdown menus.
sp = pos(2);                                                                %Set the space between elements.
pos = get(fig,'position');                                                  %Grab the figure's position.
w = pos(3);                                                                 %Set the width of the field selection figure.
objs = get(fig,'children');                                                 %Grab all children of the parent figure.
N = sum(strcmpi(get(objs,'style'),'popupmenu')) + 1;                        %Increment the current column count.
h = (N + 2.5)*(uih + sp) + sp;                                              %Set the height of the function selection figure.
pos(4) = h;                                                                 %Reset the figure height.
set(fig,'position',pos);                                                    %Update the figure height.
for i = 1:length(objs)                                                      %Step through each object.
    pos = get(objs(i),'position');                                          %Step through each object.
    pos(2) = pos(2) + uih + sp;                                             %Scoot each object up one step.
    set(objs(i),'position',pos);                                            %Update each object's position.
end
i = find(strcmpi(get(objs,'style'),'pushbutton'));                          %Find all pushbutton objects.
j = i(strcmpi(get(objs(i),'string'),'+'));                                  %Find the add column button.
addbutton = objs(j);                                                        %Save the handle for the add column button.
pos = get(addbutton,'position');                                            %Grab the add column button's position.
pos(2) = sp;                                                                %Reset the bottom edge to the very bottom of the figure.
set(objs(j),'position',pos);                                                %Update the button position.
j = i(strcmpi(get(objs(i),'string'),'Set Outputs'));                        %Find the set button.
pos = get(objs(j),'position');                                              %Grab the button's position.
pos(2) = sp;                                                                %Reset the bottom edge to the very bottom of the figure.
set(objs(j),'position',pos);                                                %Update the button position.
uicontrol(fig,'style','edit',...
    'string',num2str(N),...
    'units','centimeters',...
    'position',[sp h-(N+1.5)*(uih+sp) uih uih],...
    'fontsize',12,...
    'fontweight','bold',...
    'foregroundcolor','k',...
    'enable','inactive',...
    'userdata',N);                                                          %Create text for labeling the column number.
uicontrol(fig,'style','pushbutton',...
    'string','X',...
    'units','centimeters',...
    'position',[2*sp+uih h-(N+1.5)*(uih+sp) uih uih],...
    'fontsize',12,...
    'fontweight','bold',...
    'foregroundcolor',[0.5 0 0],...
    'userdata',N,...
    'callback',@Delete_Menu);                                               %Create a button for deleting the new column.
i = find(strcmpi(get(objs,'style'),'popupmenu'));                           %Find all popupmenu objects.
str = get(objs(i(1)),'string');                                             %Grab the string from an existing popupmenu.
vals = get(objs(i),'value');                                                %Grab the current value of all popup menus.
vals = [vals{:}];                                                           %Convert the values to a matrix.
i = 1:length(str);                                                          %Create an index for every field option.
i = setdiff(i,vals);                                                        %Find all indices that aren't already selected.
uicontrol(fig,'style','popupmenu',...
    'string',str,...
    'value',i(1),...
    'units','centimeters',...
    'position',[3*sp+2*uih h-(N+1.5)*(uih+sp) w-4*sp-2*uih uih],...
    'userdata',N,...
    'fontsize',12);                                                         %Make a pop-up menu for the new column.
objs = get(fig,'children');                                                 %Grab all children of the parent figure.
objs(~strcmpi(get(objs,'style'),'popupmenu')) = [];                         %Kick out all non-popup objects.
all_fields = get(objs(1),'string');                                         %Grab all of the available fields from the 1st object's string property.
i = get(objs,'value');                                                      %Grab the selected index from each popup menu.
selected_fields = unique(all_fields([i{:}]));                               %List the currently selected fields.
if isempty(setdiff(all_fields,selected_fields))                             %If all fields are selected...
    set(addbutton,'enable','off');                                          %Disable the "add column" button.
else                                                                        %Otherwise...
    set(addbutton,'enable','on');                                           %Enable the "add column" button.
end


%% This subfunction is called when the user presses the button to add a column.
function Delete_Menu(hObject,~)
d = get(hObject,'userdata');                                                %Grab the button index from the calling pushbutton's UserData property.
fig = gcbf;                                                                 %Grab the parent figure handle.
objs = get(fig,'children');                                                 %Grab all children of the parent figure.
i = find(strcmpi(get(objs,'style'),'pushbutton'));                          %Find all pushbutton objects.
j = i(strcmpi(get(objs(i),'string'),'+'));                                  %Find the add column button.
addbutton = objs(j);                                                        %Save the handle for the add column button.
pos = get(addbutton,'position');                                            %Grab the add column button's position.
sp = pos(2);                                                                %Set the space between elements.
uih = pos(4);                                                               %Match the height for all dropdown menus.
N = sum(strcmpi(get(objs,'style'),'popupmenu')) - 1;                        %Decrement the current column count.
h = (N + 2.5)*(uih + sp) + sp;                                              %Set the height of the function selection figure.
pos = get(fig,'position');                                                  %Grab the figure's position.
w = pos(3);                                                                 %Set the width of the field selection figure.
pos(4) = h;                                                                 %Reset the figure height.
set(fig,'position',pos);                                                    %Update the figure height.
for i = 1:length(objs)                                                      %Step through each object.
    style = get(objs(i),'style');                                           %Grab each object's style.
    index = get(objs(i),'userdata');                                        %Grab each object's index.
    if ~isempty(index)                                                      %If there's an index...
        if index < d                                                        %If the object is above the to-be-deleted column...
            pos = get(objs(i),'position');                                  %Grab the button's position.
            pos(2) = pos(2) - uih - sp;                                     %Move the object downward.
            set(objs(i),'position',pos);                                    %Update the object's position.
        elseif index == d                                                   %If the object is in the to-be-deleted column...
            delete(objs(i));                                                %Delete the object.
        else                                                                %Otherwise, if the object is below the to-be-deleted column...
            set(objs(i),'userdata',index - 1);                              %Decrement the object index.            
            if strcmpi(style,'edit')                                        %If the object is an editbox...
                set(objs(i),'string',num2str(index-1));                     %Update the number label.
            end
        end
    end
end
objs = get(fig,'children');                                                 %Grab all children of the parent figure.
objs(~strcmpi(get(objs,'style'),'popupmenu')) = [];                         %Kick out all non-popup objects.
all_fields = get(objs(1),'string');                                         %Grab all of the available fields from the 1st object's string property.
i = get(objs,'value');                                                      %Grab the selected index from each popup menu.
selected_fields = unique(all_fields([i{:}]));                               %List the currently selected fields.
if isempty(setdiff(all_fields,selected_fields))                             %If all fields are selected...
    set(addbutton,'enable','off');                                          %Disable the "add column" button.
else                                                                        %Otherwise...
    set(addbutton,'enable','on');                                           %Enable the "add column" button.
end


function path = Vulintus_Set_AppData_Path(program)

%
%Vulintus_Set_AppData_Path.m - Vulintus, Inc.
%
%   This function finds and/or creates the local application data folder
%   for Vulintus functions specified by "program".
%   
%   UPDATE LOG:
%   08/05/2016 - Drew Sloan - Function created to replace within-function
%       calls in multiple programs.
%

local = winqueryreg('HKEY_CURRENT_USER',...
        ['Software\Microsoft\Windows\CurrentVersion\' ...
        'Explorer\Shell Folders'],'Local AppData');                         %Grab the local application data directory.    
path = fullfile(local,'Vulintus','\');                                      %Create the expected directory name for Vulintus data.
if ~exist(path,'dir')                                                       %If the directory doesn't already exist...
    [status, msg, ~] = mkdir(path);                                         %Create the directory.
    if status ~= 1                                                          %If the directory couldn't be created...
        errordlg(sprintf(['Unable to create application data'...
            ' directory\n\n%s\n\nDetails:\n\n%s'],path,msg),...
            'Vulintus Directory Error');                                    %Show an error.
    end
end
path = fullfile(path,program,'\');                                          %Create the expected directory name for MotoTrak data.
if ~exist(path,'dir')                                                       %If the directory doesn't already exist...
    [status, msg, ~] = mkdir(path);                                         %Create the directory.
    if status ~= 1                                                          %If the directory couldn't be created...
        errordlg(sprintf(['Unable to create application data'...
            ' directory\n\n%s\n\nDetails:\n\n%s'],path,msg),...
            [program ' Directory Error']);                                  %Show an error.
    end
end

if strcmpi(program,'mototrak')                                              %If the specified function is MotoTrak.
    oldpath = fullfile(local,'MotoTrak','\');                               %Create the expected name of the previous version appdata directory.
    if exist(oldpath,'dir')                                                 %If the previous version directory exists...
        files = dir(oldpath);                                               %Grab the list of items contained within the previous directory.
        for f = 1:length(files)                                             %Step through each item.
            if ~files(f).isdir                                             	%If the item isn't a directory...
                copyfile([oldpath, files(f).name],path,'f');                %Copy the file to the new directory.
            end
        end
        [status, msg] = rmdir(oldpath,'s');                                 %Delete the previous version appdata directory.
        if status ~= 1                                                      %If the directory couldn't be deleted...
            warning(['Unable to delete application data'...
                ' directory\n\n%s\n\nDetails:\n\n%s'],oldpath,msg);         %Show an warning.
        end
    end
end


function waitbar = big_waitbar(varargin)

figsize = [2,16];                                                           %Set the default figure size, in centimeters.
barcolor = 'b';                                                             %Set the default waitbar color.
titlestr = 'Waiting...';                                                    %Set the default waitbar title.
txtstr = 'Waiting...';                                                      %Set the default waitbar string.
val = 0;                                                                    %Set the default value of the waitbar to zero.

str = {'FigureSize','Color','Title','String','Value'};                      %List the allowable parameter names.
for i = 1:2:length(varargin)                                                %Step through any optional input arguments.
    if ~ischar(varargin{i}) || ~any(strcmpi(varargin{i},str))               %If the first optional input argument isn't one of the expected property names...
        beep;                                                               %Play the Matlab warning noise.
        cprintf('red','%s\n',['ERROR IN BIG_WAITBAR: Property '...
            'name not recognized! Optional input properties are:']);        %Show an error.
        for j = 1:length(str)                                               %Step through each allowable parameter name.
            cprintf('red','\t%s\n',str{j});                                 %List each parameter name in the command window, in red.
        end
        return                                                              %Skip execution of the rest of the function.
    else                                                                    %Otherwise...
        if strcmpi(varargin{i},'FigureSize')                                %If the optional input property is "FigureSize"...
            figsize = varargin{i+1};                                        %Set the figure size to that specified, in centimeters.            
        elseif strcmpi(varargin{i},'Color')                                 %If the optional input property is "Color"...
            barcolor = varargin{i+1};                                       %Set the waitbar color the specified color.
        elseif strcmpi(varargin{i},'Title')                                 %If the optional input property is "Title"...
            titlestr = varargin{i+1};                                       %Set the waitbar figure title to the specified string.
        elseif strcmpi(varargin{i},'String')                                %If the optional input property is "String"...
            txtstr = varargin{i+1};                                         %Set the waitbar text to the specified string.
        elseif strcmpi(varargin{i},'Value')                                 %If the optional input property is "Value"...
            val = varargin{i+1};                                            %Set the waitbar value to the specified value.
        end
    end    
end

orig_units = get(0,'units');                                                %Grab the current system units.
set(0,'units','centimeters');                                               %Set the system units to centimeters.
pos = get(0,'Screensize');                                                  %Grab the screensize.
h = figsize(1);                                                             %Set the height of the figure.
w = figsize(2);                                                             %Set the width of the figure.
fig = figure('numbertitle','off',...
    'name',titlestr,...
    'units','centimeters',...
    'Position',[pos(3)/2-w/2, pos(4)/2-h/2, w, h],...
    'menubar','none',...
    'resize','off');                                                        %Create a figure centered in the screen.
ax = axes('units','centimeters',...
    'position',[0.25,0.25,w-0.5,h/2-0.3],...
    'parent',fig);                                                          %Create axes for showing loading progress.
if val > 1                                                                  %If the specified value is greater than 1...
    val = 1;                                                                %Set the value to 1.
elseif val < 0                                                              %If the specified value is less than 0...
    val = 0;                                                                %Set the value to 0.
end    
obj = fill(val*[0 1 1 0 0],[0 0 1 1 0],barcolor,'edgecolor','k');           %Create a fill object to show loading progress.
set(ax,'xtick',[],'ytick',[],'box','on','xlim',[0,1],'ylim',[0,1]);         %Set the axis limits and ticks.
txt = uicontrol(fig,'style','text','units','centimeters',...
    'position',[0.25,h/2+0.05,w-0.5,h/2-0.3],'fontsize',10,...
    'horizontalalignment','left','backgroundcolor',get(fig,'color'),...
    'string',txtstr);                                                       %Create a text object to show the current point in the wait process.  
set(0,'units',orig_units);                                                  %Set the system units back to the original units.

waitbar.title = @(str)SetTitle(fig,str);                                    %Set the function for changing the waitbar title.
waitbar.string = @(str)SetString(fig,txt,str);                              %Set the function for changing the waitbar string.
waitbar.value = @(val)SetVal(fig,obj,val);                                  %Set the function for changing waitbar value.
waitbar.color = @(val)SetColor(fig,obj,val);                                %Set the function for changing waitbar color.
waitbar.close = @()CloseWaitbar(fig);                                       %Set the function for closing the waitbar.
waitbar.isclosed = @()WaitbarIsClosed(fig);                                 %Set the function for checking whether the waitbar figure is closed.

drawnow;                                                                    %Immediately show the waitbar.


%% This function sets the name/title of the waitbar figure.
function SetTitle(fig,str)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(fig,'name',str);                                                    %Set the figure name to the specified string.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function sets the string on the waitbar figure.
function SetString(fig,txt,str)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(txt,'string',str);                                                  %Set the string in the text object to the specified string.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function sets the current value of the waitbar.
function SetVal(fig,obj,val)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    if val > 1                                                              %If the specified value is greater than 1...
        val = 1;                                                            %Set the value to 1.
    elseif val < 0                                                          %If the specified value is less than 0...
        val = 0;                                                            %Set the value to 0.
    end
    set(obj,'xdata',val*[0 1 1 0 0]);                                       %Set the patch object to extend to the specified value.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function sets the color of the waitbar.
function SetColor(fig,obj,val)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    set(obj,'facecolor',val);                                               %Set the patch object to have the specified facecolor.
    drawnow;                                                                %Immediately update the figure.
else                                                                        %Otherwise...
    warning('Cannot update the waitbar figure. It has been closed.');       %Show a warning.
end


%% This function closes the waitbar figure.
function CloseWaitbar(fig)
if ishandle(fig)                                                            %If the waitbar figure is still open...
    close(fig);                                                             %Close the waitbar figure.
    drawnow;                                                                %Immediately update the figure to allow it to close.
end


%% This function returns a logical value indicate whether the waitbar figure has been closed.
function isclosed = WaitbarIsClosed(fig)
isclosed = ~ishandle(fig);                                                  %Check to see if the figure handle is still a valid handle.


function count = cprintf(style,format,varargin)
% CPRINTF displays styled formatted text in the Command Window
%
% Syntax:
%    count = cprintf(style,format,...)
%
% Description:
%    CPRINTF processes the specified text using the exact same FORMAT
%    arguments accepted by the built-in SPRINTF and FPRINTF functions.
%
%    CPRINTF then displays the text in the Command Window using the
%    specified STYLE argument. The accepted styles are those used for
%    Matlab's syntax highlighting (see: File / Preferences / Colors / 
%    M-file Syntax Highlighting Colors), and also user-defined colors.
%
%    The possible pre-defined STYLE names are:
%
%       'Text'                 - default: black
%       'Keywords'             - default: blue
%       'Comments'             - default: green
%       'Strings'              - default: purple
%       'UnterminatedStrings'  - default: dark red
%       'SystemCommands'       - default: orange
%       'Errors'               - default: light red
%       'Hyperlinks'           - default: underlined blue
%
%       'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White'
%
%    STYLE beginning with '-' or '_' will be underlined. For example:
%          '-Blue' is underlined blue, like 'Hyperlinks';
%          '_Comments' is underlined green etc.
%
%    STYLE beginning with '*' will be bold (R2011b+ only). For example:
%          '*Blue' is bold blue;
%          '*Comments' is bold green etc.
%    Note: Matlab does not currently support both bold and underline,
%          only one of them can be used in a single cprintf command. But of
%          course bold and underline can be mixed by using separate commands.
%
%    STYLE also accepts a regular Matlab RGB vector, that can be underlined
%    and bolded: -[0,1,1] means underlined cyan, '*[1,0,0]' is bold red.
%
%    STYLE is case-insensitive and accepts unique partial strings just
%    like handle property names.
%
%    CPRINTF by itself, without any input parameters, displays a demo
%
% Example:
%    cprintf;   % displays the demo
%    cprintf('text',   'regular black text');
%    cprintf('hyper',  'followed %s','by');
%    cprintf('key',    '%d colored', 4);
%    cprintf('-comment','& underlined');
%    cprintf('err',    'elements\n');
%    cprintf('cyan',   'cyan');
%    cprintf('_green', 'underlined green');
%    cprintf(-[1,0,1], 'underlined magenta');
%    cprintf([1,0.5,0],'and multi-\nline orange\n');
%    cprintf('*blue',  'and *bold* (R2011b+ only)\n');
%    cprintf('string');  % same as fprintf('string') and cprintf('text','string')
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab
%    functionality. It works on Matlab 7+, but use at your own risk!
%
%    A technical description of the implementation can be found at:
%    <a href="http://undocumentedmatlab.com/blog/cprintf/">http://UndocumentedMatlab.com/blog/cprintf/</a>
%
% Limitations:
%    1. In R2011a and earlier, a single space char is inserted at the
%       beginning of each CPRINTF text segment (this is ok in R2011b+).
%
%    2. In R2011a and earlier, consecutive differently-colored multi-line
%       CPRINTFs sometimes display incorrectly on the bottom line.
%       As far as I could tell this is due to a Matlab bug. Examples:
%         >> cprintf('-str','under\nline'); cprintf('err','red\n'); % hidden 'red', unhidden '_'
%         >> cprintf('str','regu\nlar'); cprintf('err','red\n'); % underline red (not purple) 'lar'
%
%    3. Sometimes, non newline ('\n')-terminated segments display unstyled
%       (black) when the command prompt chevron ('>>') regains focus on the
%       continuation of that line (I can't pinpoint when this happens). 
%       To fix this, simply newline-terminate all command-prompt messages.
%
%    4. In R2011b and later, the above errors appear to be fixed. However,
%       the last character of an underlined segment is not underlined for
%       some unknown reason (add an extra space character to make it look better)
%
%    5. In old Matlab versions (e.g., Matlab 7.1 R14), multi-line styles
%       only affect the first line. Single-line styles work as expected.
%       R14 also appends a single space after underlined segments.
%
%    6. Bold style is only supported on R2011b+, and cannot also be underlined.
%
% Change log:
%    2012-08-09: Graceful degradation support for deployed (compiled) and non-desktop applications; minor bug fixes
%    2012-08-06: Fixes for R2012b; added bold style; accept RGB string (non-numeric) style
%    2011-11-27: Fixes for R2011b
%    2011-08-29: Fix by Danilo (FEX comment) for non-default text colors
%    2011-03-04: Performance improvement
%    2010-06-27: Fix for R2010a/b; fixed edge case reported by Sharron; CPRINTF with no args runs the demo
%    2009-09-28: Fixed edge-case problem reported by Swagat K
%    2009-05-28: corrected nargout behavior sugegsted by Andreas Gäb
%    2009-05-13: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>
%
% See also:
%    sprintf, fprintf

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.08 $  $Date: 2012/10/17 21:41:09 $

  persistent majorVersion minorVersion
  if isempty(majorVersion)
      %v = version; if str2double(v(1:3)) <= 7.1
      %majorVersion = str2double(regexprep(version,'^(\d+).*','$1'));
      %minorVersion = str2double(regexprep(version,'^\d+\.(\d+).*','$1'));
      %[a,b,c,d,versionIdStrs]=regexp(version,'^(\d+)\.(\d+).*');  %#ok unused
      v = sscanf(version, '%d.', 2);
      majorVersion = v(1); %str2double(versionIdStrs{1}{1});
      minorVersion = v(2); %str2double(versionIdStrs{1}{2});
  end

  % The following is for debug use only:
  %global docElement txt el
  if ~exist('el','var') || isempty(el),  el=handle([]);  end  %#ok mlint short-circuit error ("used before defined")
  if nargin<1, showDemo(majorVersion,minorVersion); return;  end
  if isempty(style),  return;  end
  if all(ishandle(style)) && length(style)~=3
      dumpElement(style);
      return;
  end

  % Process the text string
  if nargin<2, format = style; style='text';  end
  %error(nargchk(2, inf, nargin, 'struct'));
  %str = sprintf(format,varargin{:});

  % In compiled mode
  try useDesktop = usejava('desktop'); catch, useDesktop = false; end
  if isdeployed | ~useDesktop %#ok<OR2> - for Matlab 6 compatibility
      % do not display any formatting - use simple fprintf()
      % See: http://undocumentedmatlab.com/blog/bold-color-text-in-the-command-window/#comment-103035
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/1390a26e7ef4aa4d
      % Also see: https://mail.google.com/mail/u/0/?ui=2&shva=1#all/13a6ed3223333b21
      count1 = fprintf(format,varargin{:});
  else
      % Else (Matlab desktop mode)
      % Get the normalized style name and underlining flag
      [underlineFlag, boldFlag, style] = processStyleInfo(style);

      % Set hyperlinking, if so requested
      if underlineFlag
          format = ['<a href="">' format '</a>'];

          % Matlab 7.1 R14 (possibly a few newer versions as well?)
          % have a bug in rendering consecutive hyperlinks
          % This is fixed by appending a single non-linked space
          if majorVersion < 7 || (majorVersion==7 && minorVersion <= 1)
              format(end+1) = ' ';
          end
      end

      % Set bold, if requested and supported (R2011b+)
      if boldFlag
          if (majorVersion > 7 || minorVersion >= 13)
              format = ['<strong>' format '</strong>'];
          else
              boldFlag = 0;
          end
      end

      % Get the current CW position
      cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
      lastPos = cmdWinDoc.getLength;

      % If not beginning of line
      bolFlag = 0;  %#ok
      %if docElement.getEndOffset - docElement.getStartOffset > 1
          % Display a hyperlink element in order to force element separation
          % (otherwise adjacent elements on the same line will be merged)
          if majorVersion<7 || (majorVersion==7 && minorVersion<13)
              if ~underlineFlag
                  fprintf('<a href=""> </a>');  %fprintf('<a href=""> </a>\b');
              elseif format(end)~=10  % if no newline at end
                  fprintf(' ');  %fprintf(' \b');
              end
          end
          %drawnow;
          bolFlag = 1;
      %end

      % Get a handle to the Command Window component
      mde = com.mathworks.mde.desk.MLDesktop.getInstance;
      cw = mde.getClient('Command Window');
      xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);

      % Store the CW background color as a special color pref
      % This way, if the CW bg color changes (via File/Preferences), 
      % it will also affect existing rendered strs
      com.mathworks.services.Prefs.setColorPref('CW_BG_Color',xCmdWndView.getBackground);

      % Display the text in the Command Window
      count1 = fprintf(2,format,varargin{:});

      %awtinvoke(cmdWinDoc,'remove',lastPos,1);   % TODO: find out how to remove the extra '_'
      drawnow;  % this is necessary for the following to work properly (refer to Evgeny Pr in FEX comment 16/1/2011)
      docElement = cmdWinDoc.getParagraphElement(lastPos+1);
      if majorVersion<7 || (majorVersion==7 && minorVersion<13)
          if bolFlag && ~underlineFlag
              % Set the leading hyperlink space character ('_') to the bg color, effectively hiding it
              % Note: old Matlab versions have a bug in hyperlinks that need to be accounted for...
              %disp(' '); dumpElement(docElement)
              setElementStyle(docElement,'CW_BG_Color',1+underlineFlag,majorVersion,minorVersion); %+getUrlsFix(docElement));
              %disp(' '); dumpElement(docElement)
              el(end+1) = handle(docElement);  %#ok used in debug only
          end

          % Fix a problem with some hidden hyperlinks becoming unhidden...
          fixHyperlink(docElement);
          %dumpElement(docElement);
      end

      % Get the Document Element(s) corresponding to the latest fprintf operation
      while docElement.getStartOffset < cmdWinDoc.getLength
          % Set the element style according to the current style
          %disp(' '); dumpElement(docElement)
          specialFlag = underlineFlag | boldFlag;
          setElementStyle(docElement,style,specialFlag,majorVersion,minorVersion);
          %disp(' '); dumpElement(docElement)
          docElement2 = cmdWinDoc.getParagraphElement(docElement.getEndOffset+1);
          if isequal(docElement,docElement2),  break;  end
          docElement = docElement2;
          %disp(' '); dumpElement(docElement)
      end

      % Force a Command-Window repaint
      % Note: this is important in case the rendered str was not '\n'-terminated
      xCmdWndView.repaint;

      % The following is for debug use only:
      el(end+1) = handle(docElement);  %#ok used in debug only
      %elementStart  = docElement.getStartOffset;
      %elementLength = docElement.getEndOffset - elementStart;
      %txt = cmdWinDoc.getText(elementStart,elementLength);
  end

  if nargout
      count = count1;
  end
  return;  % debug breakpoint

% Process the requested style information
function [underlineFlag,boldFlag,style] = processStyleInfo(style)
  underlineFlag = 0;
  boldFlag = 0;

  % First, strip out the underline/bold markers
  if ischar(style)
      % Styles containing '-' or '_' should be underlined (using a no-target hyperlink hack)
      %if style(1)=='-'
      underlineIdx = (style=='-') | (style=='_');
      if any(underlineIdx)
          underlineFlag = 1;
          %style = style(2:end);
          style = style(~underlineIdx);
      end

      % Check for bold style (only if not underlined)
      boldIdx = (style=='*');
      if any(boldIdx)
          boldFlag = 1;
          style = style(~boldIdx);
      end
      if underlineFlag && boldFlag
          warning('YMA:cprintf:BoldUnderline','Matlab does not support both bold & underline')
      end

      % Check if the remaining style sting is a numeric vector
      %styleNum = str2num(style); %#ok<ST2NM>  % not good because style='text' is evaled!
      %if ~isempty(styleNum)
      if any(style==' ' | style==',' | style==';')
          style = str2num(style); %#ok<ST2NM>
      end
  end

  % Style = valid matlab RGB vector
  if isnumeric(style) && length(style)==3 && all(style<=1) && all(abs(style)>=0)
      if any(style<0)
          underlineFlag = 1;
          style = abs(style);
      end
      style = getColorStyle(style);

  elseif ~ischar(style)
      error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')

  % Style name
  else
      % Try case-insensitive partial/full match with the accepted style names
      validStyles = {'Text','Keywords','Comments','Strings','UnterminatedStrings','SystemCommands','Errors', ...
                     'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White', ...
                     'Hyperlinks'};
      matches = find(strncmpi(style,validStyles,length(style)));

      % No match - error
      if isempty(matches)
          error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')

      % Too many matches (ambiguous) - error
      elseif length(matches) > 1
          error('YMA:cprintf:AmbigStyle','Ambiguous style name - supply extra characters for uniqueness')

      % Regular text
      elseif matches == 1
          style = 'ColorsText';  % fixed by Danilo, 29/8/2011

      % Highlight preference style name
      elseif matches < 8
          style = ['Colors_M_' validStyles{matches}];

      % Color name
      elseif matches < length(validStyles)
          colors = [0,0,0; 0,1,1; 1,0,1; 0,0,1; 0,1,0; 1,0,0; 1,1,0; 1,1,1];
          requestedColor = colors(matches-7,:);
          style = getColorStyle(requestedColor);

      % Hyperlink
      else
          style = 'Colors_HTML_HTMLLinks';  % CWLink
          underlineFlag = 1;
      end
  end

% Convert a Matlab RGB vector into a known style name (e.g., '[255,37,0]')
function styleName = getColorStyle(rgb)
  intColor = int32(rgb*255);
  javaColor = java.awt.Color(intColor(1), intColor(2), intColor(3));
  styleName = sprintf('[%d,%d,%d]',intColor);
  com.mathworks.services.Prefs.setColorPref(styleName,javaColor);

% Fix a bug in some Matlab versions, where the number of URL segments
% is larger than the number of style segments in a doc element
function delta = getUrlsFix(docElement)  %#ok currently unused
  tokens = docElement.getAttribute('SyntaxTokens');
  links  = docElement.getAttribute('LinkStartTokens');
  if length(links) > length(tokens(1))
      delta = length(links) > length(tokens(1));
  else
      delta = 0;
  end

% fprintf(2,str) causes all previous '_'s in the line to become red - fix this
function fixHyperlink(docElement)
  try
      tokens = docElement.getAttribute('SyntaxTokens');
      urls   = docElement.getAttribute('HtmlLink');
      urls   = urls(2);
      links  = docElement.getAttribute('LinkStartTokens');
      offsets = tokens(1);
      styles  = tokens(2);
      doc = docElement.getDocument;

      % Loop over all segments in this docElement
      for idx = 1 : length(offsets)-1
          % If this is a hyperlink with no URL target and starts with ' ' and is collored as an error (red)...
          if strcmp(styles(idx).char,'Colors_M_Errors')
              character = char(doc.getText(offsets(idx)+docElement.getStartOffset,1));
              if strcmp(character,' ')
                  if isempty(urls(idx)) && links(idx)==0
                      % Revert the style color to the CW background color (i.e., hide it!)
                      styles(idx) = java.lang.String('CW_BG_Color');
                  end
              end
          end
      end
  catch
      % never mind...
  end

% Set an element to a particular style (color)
function setElementStyle(docElement,style,specialFlag, majorVersion,minorVersion)
  %global tokens links urls urlTargets  % for debug only
  global oldStyles
  if nargin<3,  specialFlag=0;  end
  % Set the last Element token to the requested style:
  % Colors:
  tokens = docElement.getAttribute('SyntaxTokens');
  try
      styles = tokens(2);
      oldStyles{end+1} = styles.cell;

      % Correct edge case problem
      extraInd = double(majorVersion>7 || (majorVersion==7 && minorVersion>=13));  % =0 for R2011a-, =1 for R2011b+
      %{
      if ~strcmp('CWLink',char(styles(end-hyperlinkFlag))) && ...
          strcmp('CWLink',char(styles(end-hyperlinkFlag-1)))
         extraInd = 0;%1;
      end
      hyperlinkFlag = ~isempty(strmatch('CWLink',tokens(2)));
      hyperlinkFlag = 0 + any(cellfun(@(c)(~isempty(c)&&strcmp(c,'CWLink')),tokens(2).cell));
      %}

      styles(end-extraInd) = java.lang.String('');
      styles(end-extraInd-specialFlag) = java.lang.String(style);  %#ok apparently unused but in reality used by Java
      if extraInd
          styles(end-specialFlag) = java.lang.String(style);
      end

      oldStyles{end} = [oldStyles{end} styles.cell];
  catch
      % never mind for now
  end
  
  % Underlines (hyperlinks):
  %{
  links = docElement.getAttribute('LinkStartTokens');
  if isempty(links)
      %docElement.addAttribute('LinkStartTokens',repmat(int32(-1),length(tokens(2)),1));
  else
      %TODO: remove hyperlink by setting the value to -1
  end
  %}

  % Correct empty URLs to be un-hyperlinkable (only underlined)
  urls = docElement.getAttribute('HtmlLink');
  if ~isempty(urls)
      urlTargets = urls(2);
      for urlIdx = 1 : length(urlTargets)
          try
              if urlTargets(urlIdx).length < 1
                  urlTargets(urlIdx) = [];  % '' => []
              end
          catch
              % never mind...
              a=1;  %#ok used for debug breakpoint...
          end
      end
  end
  
  % Bold: (currently unused because we cannot modify this immutable int32 numeric array)
  %{
  try
      %hasBold = docElement.isDefined('BoldStartTokens');
      bolds = docElement.getAttribute('BoldStartTokens');
      if ~isempty(bolds)
          %docElement.addAttribute('BoldStartTokens',repmat(int32(1),length(bolds),1));
      end
  catch
      % never mind - ignore...
      a=1;  %#ok used for debug breakpoint...
  end
  %}
  
  return;  % debug breakpoint

% Display information about element(s)
function dumpElement(docElements)
  %return;
  numElements = length(docElements);
  cmdWinDoc = docElements(1).getDocument;
  for elementIdx = 1 : numElements
      if numElements > 1,  fprintf('Element #%d:\n',elementIdx);  end
      docElement = docElements(elementIdx);
      if ~isjava(docElement),  docElement = docElement.java;  end
      %docElement.dump(java.lang.System.out,1)
      disp(' ');
      disp(docElement)
      tokens = docElement.getAttribute('SyntaxTokens');
      if isempty(tokens),  continue;  end
      links = docElement.getAttribute('LinkStartTokens');
      urls  = docElement.getAttribute('HtmlLink');
      try bolds = docElement.getAttribute('BoldStartTokens'); catch, bolds = []; end
      txt = {};
      tokenLengths = tokens(1);
      for tokenIdx = 1 : length(tokenLengths)-1
          tokenLength = diff(tokenLengths(tokenIdx+[0,1]));
          if (tokenLength < 0)
              tokenLength = docElement.getEndOffset - docElement.getStartOffset - tokenLengths(tokenIdx);
          end
          txt{tokenIdx} = cmdWinDoc.getText(docElement.getStartOffset+tokenLengths(tokenIdx),tokenLength).char;  %#ok
      end
      lastTokenStartOffset = docElement.getStartOffset + tokenLengths(end);
      txt{end+1} = cmdWinDoc.getText(lastTokenStartOffset, docElement.getEndOffset-lastTokenStartOffset).char;  %#ok
      %cmdWinDoc.uiinspect
      %docElement.uiinspect
      txt = strrep(txt',sprintf('\n'),'\n');
      try
          data = [tokens(2).cell m2c(tokens(1)) m2c(links) m2c(urls(1)) cell(urls(2)) m2c(bolds) txt];
          if elementIdx==1
              disp('    SyntaxTokens(2,1) - LinkStartTokens - HtmlLink(1,2) - BoldStartTokens - txt');
              disp('    ==============================================================================');
          end
      catch
          try
              data = [tokens(2).cell m2c(tokens(1)) m2c(links) txt];
          catch
              disp([tokens(2).cell m2c(tokens(1)) txt]);
              try
                  data = [m2c(links) m2c(urls(1)) cell(urls(2))];
              catch
                  % Mtlab 7.1 only has urls(1)...
                  data = [m2c(links) urls.cell];
              end
          end
      end
      disp(data)
  end

% Utility function to convert matrix => cell
function cells = m2c(data)
  %datasize = size(data);  cells = mat2cell(data,ones(1,datasize(1)),ones(1,datasize(2)));
  cells = num2cell(data);

% Display the help and demo
function showDemo(majorVersion,minorVersion)
  fprintf('cprintf displays formatted text in the Command Window.\n\n');
  fprintf('Syntax: count = cprintf(style,format,...);  click <a href="matlab:help cprintf">here</a> for details.\n\n');
  url = 'http://UndocumentedMatlab.com/blog/cprintf/';
  fprintf(['Technical description: <a href="' url '">' url '</a>\n\n']);
  fprintf('Demo:\n\n');
  boldFlag = majorVersion>7 || (majorVersion==7 && minorVersion>=13);
  s = ['cprintf(''text'',    ''regular black text'');' 10 ...
       'cprintf(''hyper'',   ''followed %s'',''by'');' 10 ...
       'cprintf(''key'',     ''%d colored'',' num2str(4+boldFlag) ');' 10 ...
       'cprintf(''-comment'',''& underlined'');' 10 ...
       'cprintf(''err'',     ''elements:\n'');' 10 ...
       'cprintf(''cyan'',    ''cyan'');' 10 ...
       'cprintf(''_green'',  ''underlined green'');' 10 ...
       'cprintf(-[1,0,1],  ''underlined magenta'');' 10 ...
       'cprintf([1,0.5,0], ''and multi-\nline orange\n'');' 10];
   if boldFlag
       % In R2011b+ the internal bug that causes the need for an extra space
       % is apparently fixed, so we must insert the sparator spaces manually...
       % On the other hand, 2011b enables *bold* format
       s = [s 'cprintf(''*blue'',   ''and *bold* (R2011b+ only)\n'');' 10];
       s = strrep(s, ''')',' '')');
       s = strrep(s, ''',5)',' '',5)');
       s = strrep(s, '\n ','\n');
   end
   disp(s);
   eval(s);


%%%%%%%%%%%%%%%%%%%%%%%%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%
% - Fix: Remove leading space char (hidden underline '_')
% - Fix: Find workaround for multi-line quirks/limitations
% - Fix: Non-\n-terminated segments are displayed as black
% - Fix: Check whether the hyperlink fix for 7.1 is also needed on 7.2 etc.
% - Enh: Add font support


function [files, varargout] = file_miner(folders,str)

if nargin == 1                                                              %If the user didn't specify a search directory.
    str = folders;                                                          %Set the string variable to what the user entered for the folder.
    folders = uigetdir(cd,['Select macro directory to search for "'...
        str '"']);                                                          %Have the user choose a starting directory.
    if folders(1) == 0                                                      %If the user clicked "cancel"...
        return                                                              %Skip execution of the rest of the function.
    end
end
if ~iscell(folders)                                                         %If the directories input is not yet a cell array...
    folders = {folders};                                                    %Convert the directories input to a cell array.
end
if ~iscell(str)                                                             %If the search string isn't a cell array...
    str = {str};                                                            %Convert the search string to a cell array.
end
str = str(:);                                                               %Make sure the search string cell array has a singleton dimension.
for f = 1:length(folders)                                                   %Step through each specified directory...
    if folders{f}(end)  ~= '\'                                              %If a directory doesn't end in a forward slash...
        folders{f}(end+1) = '\';                                            %Add a forward slash to the end of the main path.
    end
end

varargout = {[],[]};                                                        %Set the optional output arguments to empty brackets by default.

waitbar = big_waitbar('title','Finding all subfolders...','color','r');     %Create a waitbar figure.
checker = zeros(1,length(folders));                                         %Create a checking matrix to see if we've looked in all the subfolders.
while any(checker == 0)                                                     %Keep looking until all subfolders have been checked for *.xls files.
    a = find(checker == 0,1,'first');                                       %Find the next folder that hasn't been checked for subfolders.
    temp = dir(folders{a});                                                 %Grab all the files and folders in the current folder.
    if waitbar.isclosed()                                                   %If the user closed the waitbar figure...
        files = [];                                                         %Return an empty matrix.
        return                                                              %Skip execution of the rest of the function.
    else                                                                    %Otherwise...
        b = find(folders{a}(1:end-2) == '\',1,'last');                      %Find the last forward slash.
        if isempty(b)                                                       %If no forward slash was found...
            b = 1;                                                          %Set the index to 1.
        end
        waitbar.string(sprintf('Checking: %s',folders{a}(b:end)));          %Update the waitbar text.
        waitbar.value(sum(checker)/length(checker));                        %Update the waitbar value.
    end
    for f = 1:length(temp)                                                  %Step through all of the returned contents.
        if ~any(temp(f).name == '.') && temp(f).isdir == 1                  %If an item is a folder, but not a system folder...
            subfolder = [folders{a} temp(f).name '\'];                      %Concatenate the full subfolder name...
            if ~any(strcmpi(subfolder,folders))                             %If the subfolder is not yet in the list of subfolders...                
                folders{end+1} = [folders{a} temp(f).name '\'];             %Add the subfolder to the list of subfolders.
                checker(end+1) = 0;                                         %Add an entry to the checker matrix to check this subfolder for more subfolders.
            end
        end
    end
    checker(a) = 1;                                                         %Mark the last folder as having been checked.        
end

N = 0;                                                                      %Create a file counter.
for i = 1:length(str)                                                       %Step through each search string.
    waitbar.title(['Counting ' str{i} ' files...']);                        %Update the title on the waitbar.
    for f = 1:length(folders)                                               %Step through every subfolder.
        temp = dir([folders{f} str{i}]);                                    %Grab all the matching filenames in the subfolder.
        N = N + length(temp);                                               %Add the number of files to the file counter.
        if waitbar.isclosed()                                               %If the user closed the waitbar figure...
            files = [];                                                     %Return an empty matrix.
            return                                                          %Skip execution of the rest of the function.
        else                                                                %Otherwise...
            b = find(folders{f}(1:end-2) == '\',1,'last');                  %Find the last forward slash.
            if isempty(b)                                                   %If no forward slash was found...
                b = 1;                                                      %Set the index to 1.
            end
            waitbar.string(sprintf('Checking: %s',folders{f}(b:end)));      %Update the waitbar text.
            waitbar.value(f/length(folders));                               %Update the waitbar value.
        end
    end
end

files = cell(N,1);                                                          %Create an empty cell array to hold filenames.
file_times = zeros(N,1);                                                    %Create a matrix to hold file modification dates.
wait_step = ceil(length(files)/100);                                        %Find an even stepsize for displaying progress on the waitbar.
N = 0;                                                                      %Reset the file counter.
for i = 1:length(str)                                                       %Step through each search string.
    waitbar.title(['Saving ' str{i} ' filenames...']);                      %Update the title on the waitbar.
    for f = 1:length(folders)                                               %Step through every subfolder.
        temp = dir([folders{f} str{i}]);                                    %Grab all the matching filenames in the subfolder.
        for j = 1:length(temp)                                              %Step through every matching file.
            if ~all(temp(j).name == '.')                                    %If the filename isn't a hidden folder.
                N = N + 1;                                                  %Increment the file counter.
                files{N} = [folders{f} temp(j).name];                       %Save the filename with it's full path.
                file_times(N) = temp(j).datenum;                            %Save the last file modification date.
                if waitbar.isclosed()                                       %If the user closed the waitbar figure...
                    files = [];                                             %Return an empty matrix.
                    return                                                  %Skip execution of the rest of the function.
                elseif rem(N,wait_step) == 0                                %Otherwise, if it's time to update the waitbar...
                    waitbar.string(sprintf('Indexing: %s',temp(j).name));   %Update the waitbar text.
                    waitbar.value(N/length(files));                         %Update the waitbar value.
                    drawnow;                                                %Update the plot immediately.
                end
            end
        end
    end
end

waitbar.close();                                                            %Close the waitbar.

varargout{1} = file_times;                                                  %Return the file modification times as an optional output argument.
varargout{2} = folders;                                                     %Return the folders cell array as an optional output argument.
drawnow;                                                                    %Update all figures to close the waitbar.


