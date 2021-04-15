%% Analysis of ASD Stress Test %%
% I want this thing to run and compile all the images from a single well
% into a single folder such that they are easy to open in ImageJ

% Best used for long experiments where individual wells are imaged
% repeatedly. It will look through several batchID folders to gather the
% images needed

%Fix: if the temporary folder already exists, allow program to skip line
%that makes folder

tic
clear all

%% Initialization
Filepath = '\\IMAGERPC22WJ6Y1\RockMakerStorage\WellImages\38\plateID_1038\';
    %Filepath should include the plateID

%Z-Plane selecion: 
Z_Method = 0; %0 = automatic selection of brightest frame. 1 = manual selection
    z_plane = '13.png'; %If Z_Method = 1. Needs to look like 'x.png' where x is the plane of choice

profileID = 'profileID_14'; %This must be the correct foldername

Destination = 'D:\Temp Imported Data\Scott\';

%%
mkdir('temporary_images');
folder_info = dir(Filepath);
batchList = {folder_info.name}.';
wellList = dir(strcat(Filepath, folder_info(3).name));
well_strings = {wellList.name}.'; %.' does a transpose on the array

for i2 = 3:length(wellList);
    renamedImages_folder = strcat(Destination,well_strings(i2),'\');
    mkdir(renamedImages_folder{1,1});
    
    for i1 = 3:length(batchList);
           current_folder = strcat(Filepath,batchList(i1),'\',well_strings(i2),'\',profileID,'\');
           current_dir = dir(current_folder{1,1});
           %find correct z-plane 
           if Z_Method == 1;
               current_cell_array = {current_dir.name};
               current_index = strfind(current_cell_array, z_plane);
               current_index = find(~cellfun(@isempty,current_index));
           end
           if Z_Method == 0;
                for i3 = 4:length(current_dir)-1;
                    current_image = imread(strcat(current_folder{1,1}, current_dir(i3).name));
                    current_score(i3,1) = mean(mean(current_image));
                    [max_score,current_index] = max(current_score);
                    clear current_image
                end
                clear current_score
           end
           
           file_to_copy = strcat(current_folder{1,1}, current_dir(current_index).name);
           copyfile(file_to_copy, 'temporary_images\');
           tempfolderInfo = dir('temporary_images\');
           a = strcat('temporary_images\', tempfolderInfo(3).name);
           b = strcat(current_dir(8).date, '.png');
           b_mod = regexprep(b, ':','');
           b_mod = regexprep(b_mod, ' ','_');
           b_final = strcat(renamedImages_folder, b_mod);
           movefile(a, b_final{1,1});
    end

end
rmdir('temporary_images');
toc

%Caution, if code fails, temporary folder needs to be deleted. It can be
%found in the current Matlab Folder.