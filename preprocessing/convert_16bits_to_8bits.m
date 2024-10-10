%% convert 16bits image to 8 bits
file_path = 'F:\zrk\thyroid\liuqunying\2024.8.20_jzx_liuqunying_2_447nm';
% norm_factor = 512;  % usaf
% norm_factor = 3.5;   %human brain
norm_factor = 3.5;   % pressed
% norm_factor = 3.0;   % unpressed
% norm_factor = 50;  % beads
img_used_array = [];
file_path = [file_path '\'];
files = dir([file_path 'Mosaic_*.tif']);
files_sorted = natsortfiles(files);
write_path = [strip(file_path, 'right', '\')  '_8bits\'];
mkdir(write_path)

file_no = numel(files_sorted);

% check data bits, determine global max for normalization
first_file = [file_path files_sorted(1).name];
first_image = imread(first_file);
max_array = zeros(file_no,1);
min_array = zeros(file_no,1);
mode_array = zeros(file_no,1);

if isa(first_image, 'uint8')
        disp('8 bits image, break.');
    elseif isa(first_image, 'uint16')
        for i = 1:file_no
            current_img = imread([file_path files_sorted(i).name]);
            current_max = max(current_img(:));
            current_min = min(current_img(:));
            current_mode =  double(mode(current_img(:)));
            max_array(i,1) = current_max;
            min_array(i,1) = current_min;
            mode_array(i, 1) = current_mode;
        end
end

global_max = max(max_array(:));
global_min = min(min_array(:));
norm_max = (mean(mode_array) - global_min) * norm_factor;
% norm_max = 7.3e3;
% normalize and save as 8bits
for i=1:file_no
    current_filename = [file_path files_sorted(i).name];
    raw_image = double(imread(current_filename));
    normed_img = (raw_image - global_min) ./ norm_max;
    new_file_path = [write_path files_sorted(i).name];
    imwrite(normed_img, new_file_path);
end