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