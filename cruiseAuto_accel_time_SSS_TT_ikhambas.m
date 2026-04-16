function[t_start] = accel_time(speed_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
%Goes through a velocity-time data set to find where the true times for  
% acceleration are, to prevent noise from affecting the findings. This will 
%return the value t for when the sustained acceleration starts 
%
% Function Call
% accel_time(data); 
%
% Input Arguments
% speed_data (the input matrix of data)
%
% Output Arguments
% t_start (the time of acceleration)
%
% Assignment Information
%   Assignment:     Cruise Auto - accel_time 
%   Version:        M4
%   Primary author: Ishaan Khambaswadkar, ikhambas@purdue.edu
%   Team members:   Aarav Jain, jain925@purdue.edu [repeat for each person]
%                   Abir Anajpur, aanajpur@purdue.edu [repeat for each person]
%                   Nathan Lee, lee5698@purdue.edu [repeat for each person]
%   Team ID:        015-19

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

time = speed_data(:,1);
velocity = speed_data(:,2);
lookahead = 5;
windowSize = 5;
%% ____________________
%% CALCULATIONS

filt = ones(1, windowSize) / windowSize; %filterr
velocity_smooth = conv(velocity, filt, 'same');

baseline = mean(velocity_smooth(1:3));
threshold = baseline + 0.1 * max(velocity_smooth);
t_start = NaN; % default if nothing found

for i = 1:length(velocity_smooth) - lookahead

    % Condition 1: above threshold
    if velocity_smooth(i) > threshold

        % Condition 2: sustained increase (look ahead)
        future_segment = velocity_smooth(i:i+lookahead);
        diffs = diff(future_segment);

        if mean(diffs) > 0.5 

            t_start = time(i);
            

        end
     end
end
end

%% ____________________
%% FORMATTED TEXT/FIGURE DISPLAYS


%% ____________________
%% RESULTS



