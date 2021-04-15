%% Analysis of ASD Stress Test %%
% I want this program to go through all the wells I have looked at for 1
% run and gather all the brightest frames into a single folder. 

% I might have it add together the whole field of view to get an idea of
% the percent crystallinity

%This program will go through a particular batchID folder to get all the
%images together.

tic
clear all

%% Initialization
% Filepath = 'D:\Temp Imported Data\Flow Cell Data\batchID_5053\';
Filepath = '\\10.164.16.234\Data\NitaTakanti\Abbvie\March23_CEiST_allsamples\batchID_9118\';

%Z-Plane selecion: 
Z_Method = 2; %0 = automatic selection of brightest frame. 1 = summation of all frames to a single image
              %2 = Pick a frame out of a stack
              Z_plane = 3; %Only used if Z_Method == 2. 
              
profileID = 'profileID_12'; %This must be the correct foldername

Destination = '\\10.164.16.234\Data\NitaTakanti\Abbvie\ProcessedImages\March 23 CEiST_v2\';

%%
mkdir(Destination)
mkdir('temporary_images');
wellList = dir(Filepath);
well_strings = {wellList.name}.'; %.' does a transpose on the array
Z_plane = strcat(num2str(Z_plane),'.png');
%%

for i2 = 3:length(wellList);    
%    current_folder = strcat(Filepath,well_strings(i2),'\');
   current_folder = strcat(Filepath,well_strings(i2),'\',profileID,'\');
   current_dir = dir(current_folder{1,1});
   %find correct z-plane 
   if Z_Method == 1;
       summed_image = zeros(512,512);
       summed_image = im2uint8(summed_image);
       for i3 = 4:length(current_dir)-1;
           current_image = imread(strcat(current_folder{1,1}, current_dir(i3).name));
           summed_image = summed_image + current_image;
       end
       imwrite(summed_image, strcat(Destination, well_strings{i2,1}, '.png'));
   end
   if Z_Method == 0;
        for i3 = 4:length(current_dir)-1;
            current_image = imread(strcat(current_folder{1,1}, current_dir(i3).name));
            current_score(i3,1) = mean(mean(current_image));
            [max_score,current_index] = max(current_score);
            clear current_image
        end
        clear current_score
        file_to_copy = strcat(current_folder{1,1}, current_dir(current_index).name);
        copyfile(file_to_copy, 'temporary_images\');
        tempfolderInfo = dir('temporary_images\');
        a = strcat('temporary_images\', tempfolderInfo(3).name);
        b = strcat(current_dir(3).date, '.png');
        b_mod = regexprep(b, ':','');
        b_mod = regexprep(b_mod, ' ','_');
        b_final = strcat(Destination, b_mod);
        movefile(a, b_final);
   end
   if Z_Method == 2;
       current_cell_array = {current_dir.name};
       current_index = strfind(current_cell_array, Z_plane);
       current_index = find(~cellfun(@isempty,current_index));
       
       
%        file_to_copy = strcat(current_folder{1,1}, current_dir(current_index).name);
       
       file_to_copy = strcat(current_folder{1,1}, current_dir(current_index(1)).name);
       
       copyfile(file_to_copy, 'temporary_images\');
       tempfolderInfo = dir('temporary_images\');
       a = strcat('temporary_images\', tempfolderInfo(3).name);
       b = strcat(current_dir(3).date, '.png');
       b_mod = regexprep(b, ':','');
       b_mod = regexprep(b_mod, ' ','_');
       b_final = strcat(Destination, b_mod);
       movefile(a, b_final);     
   end
end


% rmdir('temporary_images');
toc

%Caution, if code fails, temporary folder needs to be deleted. It can be
%found in the current Matlab Folder.