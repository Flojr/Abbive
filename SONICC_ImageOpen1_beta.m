%% Analysis of DSC-SHG Images %%
tic
clear all
%open files 

%This program is unique such that all wells imaged the same spot (see
%plate_type 'One Spot' on the Formulatrix. Currently it only works with a
%sinlge frame. The single frame is selected on line 24

%% Initialization
Filepath = 'D:\Temp Imported Data\DSC&SHG Data\urea3';
folder_info = dir(Filepath);
sampleName = 'test';

profileID = '12'; %14 == SHG High

Destination = 'D:\Temp Imported Data\DSC&SHG Data\Temp Gathered Images\';

Multiple_frames = 1;
    average_frames = 1;
    number_of_frames = 2;
%% Gather Images to a single folder

for i = 3:length(folder_info)
    image_to_write{i} = zeros(512,512);
    temp_folder = strcat(Filepath,'\', folder_info(i).name, '\profileID_', profileID, '\');
    temp_folder_info = dir(temp_folder);
    for j = 3:3+number_of_frames;
        temp_image = imread(strcat(temp_folder, temp_folder_info(j).name)); %4 corresponds to the 1st z-frame
        image_to_write{i} = image_to_write + temp_image;
        %temp_name = strcat(temp_folder, temp_folder_info(3+j).date);       
    end
    image_to_write{i} = image_to_write{i} / number_of_frames;
    %imwrite(image_to_write{i}, temp_name);
end


%% Gathering images

end_point = length(folder_info);
for i = 1:length(folder_info) - 2
    images_to_write{i} = zeros(512,512);
end
while i <= end_point
    

    
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

