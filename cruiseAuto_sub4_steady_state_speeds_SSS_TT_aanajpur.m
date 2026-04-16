function [yL, yH] = cruiseAuto_sub4_steady_state_speeds_SSS_TT_aanajpur(time_vec, speed_vec_clean, t_start)
%Structured Comment Block 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Subfunction Name: sub4_steady_state_speeds 

% 

%% Model Representation: 
% In a first order response, the system transitions from an initial steady-state % speed(yL) to a final steady state speed (yH). To find the magnitude of the step % change you just (yH-yL).  
% 

%% Subfunction Task: 

% 1. Identify the steady-state speed before acceleration (yL)  
% 2. Identify the steady-state speed after settling (yH) 

%% Calculation Logic: 
% 1. Select speed values where time < ts 

% 2. Compute yL as the mean of the pre-acceleration window 

% 3. Select speed values in the end portion fo the dataset(choose last 20% of the % time range)  

% 4. Compute yH from the mean of that final selected time frame.  

%% Input Arguments: 

% 1. time_vec: time vector for a trial(1d array) comes from data handling  

% subfunction 

% 2. speed_vec_clean: cleaned speed vector from a trial(1d array) comes from data % handling subfunction  

% 3. t_s: identified acceleration start time(s), from subfunction 2 acceleration % start 

%% Output Arguments: 

% 1. yL: initial steady state speed before acceleration. It will go to the first-% order model equation, will be plugged into sub function 3 as well 
% 2. yH: final steady-state speed after settling. It will go to the first-order  

% model equation and it will be an input to sub function 3 

%% Example Function Call (from main program): 

% [yL, yH] = sub4_steada_state_speeds(time_vec, speed_vec_clean, t_s) 

% 

%% Independent Test Case and Function Call: 
% 	Test Dataset: M1 processed data for a compact summer tire  

% 	Command Window Call: [test_yL, test_yH] = sub4_steady_state_speeds(test_time, test_speed, 5.0) 

% 	Test Criteria: output: yL near 0 m/s and yH near 24.6, both outputs are 

% scalar  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Step 1: select speed where time < t_s

pre_mask = time_vec < t_start; 

pre_speed = speed_vec_clean(pre_mask); 

% Step 2: compute yL as mean of values before acceleration 

yL = mean(pre_speed, 'omitnan'); 

% Step 3: select speed values when the car has definetely stopped
% accelerating so around the last 20%  

t_start = time_vec(1); 
t_end = time_vec(end);
t_cutoff = t_end - 0.20 * (t_end - t_start);
post_mask = time_vec >= t_cutoff; 
post_speed = speed_vec_clean(post_mask);

% Step 4: Compute yH as a mean of the final 20% window 

yH = mean(post_speed);
