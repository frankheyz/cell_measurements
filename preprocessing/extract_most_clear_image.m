function extract_most_clear_image(file_path)
    %% read stack images
    % clc;clear;
    % file_path = 'F:\zrk\thyroid\wujunxia\2024.8.14_jzx_wujunxia_2_447nm';
    file_path = [file_path '\'];
    files = dir([file_path 'Mosaic_*.tif']);
    files_sorted = natsortfiles(files);
    write_path = [file_path(1:end-1)  '_most_clear\'];
    mkdir(write_path)
    resize_factor = 1;
    thick_sample = 0;
    blur_score_list = [];
    
    % global max = 65535
    % use the 4th _ as the seperator
    
    file_no = numel(files_sorted);
    global_max = 65535;
    max_penalty_threshold = 20;
    
    lateral_pos_set = [];
    blur_score_list = [];
    max_value_list = [];
    file_name_list = {};
    
    lowest_score = 1e8;
    lowest_file_in_one_pos = '';
    scale_num = 5;
    
    counter = 0;
    
    if thick_sample == 1
        multiplier = -1;
    else
        multiplier = 1;
    end
    
    for i=1:file_no
        current_filename = [file_path files_sorted(i).name];
        file_lateral_pos = split(files_sorted(i).name, '_');
        file_lateral_pos_str = join(file_lateral_pos(1:3), '_');
        
         % read image
        current_file = imresize(double(imread(current_filename)), resize_factor);
        % add image to stack_to_be_merged
        [size_x, size_y, size_z] = size(current_file);
        % record filename
        file_name_list{end+1} = current_filename;
       
        
        % calculate blur score
    %     fm = multiplier * multiscale_morph(current_file, scale_num);
        
    %     fm = sqrt(std2(current_file)/mean2(current_file)); % tamura coefficient
    %     current_score = sum(fm(:));
        fm = fmeasure(current_file, 'LAPD');
        
        current_max = max(current_file(:));
        % record max_val
        
        
        current_score = -fm;
        
    %     current_score =  - estimate_sharpness(current_file);
        
    
        if ismember(file_lateral_pos_str{1}, lateral_pos_set)
            % add blur score
            blur_score_list = [blur_score_list current_score];
            % record max value
            max_value_list = [max_value_list current_max];
            % record file name
            file_name_list{end+1} = current_filename;
            
    %         if current_score < lowest_score
    %             lowest_score = current_score;
    %             lowest_file_in_one_pos = current_filename;
    %             lowest_blur_image = current_file;
    %         end
            
    
        else % new file prefix detected
            % if blur_score_list is not empty, write the shapest one
            if numel(blur_score_list) ~= 0  
                % find the sharpest one
                blur_score_list
                max_value_list
                if max(max_value_list) - min(max_value_list) > max_penalty_threshold
                    blur_score_list = blur_score_list + max_value_list;
                end
    
                [min_va, min_idx] = min(blur_score_list);
                % write image
                imwrite(imread(file_name_list{min_idx}), [write_path 'tile_' int2str(counter) '.tif'])
                counter = counter + 1;
                
                % reset score
    %             lowest_score = current_score;
    %             lowest_file_in_one_pos = current_filename;
                blur_score_list = [];
                blur_score_list = [blur_score_list current_score];
    
                % reset file_name_list
                file_name_list = {};
                file_name_list{end+1} = current_filename;
    
                % reset max_val_list;
                max_value_list = [];
                max_value_list(end+1) = current_max;
    
            else
    %             lowest_score = current_score;
    %             lowest_file_in_one_pos = current_filename;
    %             lowest_blur_image = current_file;
                blur_score_list = [blur_score_list current_score];
                max_value_list(end+1) = current_max;
            end
            lateral_pos_set{end+1} = file_lateral_pos_str{1};
            
        end
    end
    
    blur_score_list
    % write the last one
     [min_va, min_idx] = min(blur_score_list);
     imwrite(imread(file_name_list{min_idx}), [write_path 'tile_' int2str(counter) '.tif'])
end