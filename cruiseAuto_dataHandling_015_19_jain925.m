function [time_vec, speed_vec, metadata] = cruiseAuto_dataHandling_015_19_jain925(data_file)

    %sub1_data_handler - Imports, cleans, and normalizes raw ACC speed test
    %data
    %
    % Inputs: 
    %   filepath - string to the CSV data file
    % Outputs: 
    %   time_vec_norm - normalized time vector with the acceleration start
    %   time at 5s
    %
    %   speed_vec_clean - cleaned speed vector (m/s)
    %
    %   data - struct with fields: vehicle, tire, trial_id
    table = readtable(data_file); 
    time_vec = table{:, 1};
    speed_vec = table{:,2};
    % Get the column name split it at _ and then get the necessary data 
    col_name = table.Properties.VariableNames{2}; 
    parts = strsplit(col_name, "_"); 
    num_parts = length(parts);

    % Accounts for how many parts there are
    if num_parts >= 4
        metadata.vehicle = parts{2}; 
        metadata.tire = parts{3}; 
        metadata.trial_id = parts{4}; 
    elseif num_parts == 3
        metadata.vehicle = parts{2}; 
        metadata.tire = parts{3};  
    else
        metadata.vehicle = col_name;
        metadata.tire = "Unknown";
        metadata.trial_id = "N/A";
    end


    % Array that defines if the value needs to be updated
    flag = false(size(speed_vec));


    % Detect the frozen readings window size = 5
    window_size = 5; 
    speed_diff = diff(speed_vec);  
    count = 0; 
    for k = 1:length(speed_diff)
        if speed_diff(k) == 0
            count=count+1; 
        else
            if count >= (window_size - 1)
                flag((k-count+1):k) = true; 
            end
            count = 0; 
        end
    end

    %Check if frozen sequences extends all the way to the end 
    if count >= window_size
        flag((length(speed_diff) - count + 2):end) = true; 
    end 
    % Make all the missing values to be true 
    flag(isnan(speed_vec)) = true; 
    
    % Detect spikes using slididng window (choose 3 dtd from the mean in
    % the window) 
    window_size = 15; 
    n = length(speed_vec);

    for k = 1:n
        % Define the window bounds using floor to make sure it doesnt
        % exceed past certain bounds 
        start_pointer = max(1, k-floor(window_size/2)); 
        end_pointer = min(n, k+floor(window_size/2)); 
        window_vals = speed_vec(start_pointer:end_pointer); 


        % Remove already flagged points from the windows 
        window_flags = flag(start_pointer:end_pointer); 
        
        %~is used to invert all of the flags
        mask = ~window_flags; 
        valid_window = window_vals(mask); 

        if length(valid_window) > 2 
            local_mean = mean(valid_window);
            local_std = std(valid_window);
            if abs(speed_vec(k) - local_mean) > (3*local_std)
                flag(k) = true; 
            end 
        end 
    end 

    % Replace all of the points flagged as problemated with a linear
    % interpolation 

    valid_idx = find(~flag);
    flagged_idx = find(flag);

    if ~isempty(flagged_idx) && length(valid_idx) >= 2
        speed_vec(flagged_idx) = interp1(valid_idx, speed_vec(valid_idx), flagged_idx, 'linear', 'extrap'); 
    end 

    % Estimate the raw acceleration start time

    % Find the first points where rate of change exceeds a threshold 
    speed_gradient = diff(speed_vec) ./ diff(time_vec); 
    accel_threshold = 0.5; 

    accel_start_idx = find(speed_gradient > accel_threshold, 1); 

    if isempty(accel_start_idx)
        % Just in case no clear acceleration is detected just use the
        % midpoint
        t_s_raw = time_vec(round(length(time_vec) / 2)); 
        warning("No clear acceleration detected"); 
    else 
        t_s_raw = time_vec(accel_start_idx); 
    end 

    % Normalize the time so accel t = 5s
    delta_t = 5-t_s_raw; 
    time_vec = time_vec + delta_t;
end 
