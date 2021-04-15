%% Analysis of DSC-SHG Images %%
tic
clear all
%open files 

%This program is unique such that all wells imaged the same spot (see
%plate_type 'One Spot' on the Formulatrix. Currently it only works with a
%sinlge frame. 

%Notes to self: (Future improvements)
%Need to add in functionality where it will average the frames.. then what
%do we do for the time stamp? -Take the average maybe...


%% Initialization
Filepath = '\\IMAGERPC22WJ6Y1\RockMakerStorage\WellImages\10\plateID_1010\batchID_5253';
folder_info = dir(Filepath);
sampleName = 'Gathered';

profileID = '19'; %14 == SHG High

Destination = 'D:\Temp Imported Data\2018-07-05\';

%% Gather Images to a single folder

for i = 3:length(folder_info)
    temp_folder = strcat(Filepath,'\', folder_info(i).name, '\profileID_', profileID, '\');
    temp_folder_info = dir(temp_folder);
    file_to_copy = strcat(temp_folder, temp_folder_info(4).name); %4 corresponds to the 1st z-frame
    copyfile(file_to_copy, Destination);       
end

%% Undo the raster pattern
dest_folder_info = dir(Destination);
end_point = length(dest_folder_info);
status = 3;


renamedImages_folder = strcat(Filepath,'_',sampleName,'\'); %'D:\Temp Imported Data\DSC&SHG Data\Renamed Images\';
mkdir(renamedImages_folder);

while status <= end_point
    a = strcat(Destination, dest_folder_info(status).name);
    b = strcat(dest_folder_info(status).date, '.png');
    b_mod = regexprep(b, ':','');
    b_final = strcat(renamedImages_folder, b_mod);
    
    movefile(a, b_final);
    
    status = status + 1;
end

toc
% %% Testing
% Test_file = 'D:\Temp Imported Data\Test\d1_r28786_fl_1.png';
% Test_filepath = 'D:\Temp Imported Data\Test\';
% dinfo = dir(Test_filepath);
% 
% movefile(strcat(Test_filepath, dinfo(6).name), strcat('D:\Temp Imported Data\Test\Renamed images',dinfo(6).date,'.png')
% 

