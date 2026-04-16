function cruiseAuto_main_M4_015_19()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Coordinates Alpha Version of CruiseAuto algorithm. Imports data, 
% identifies accel start, steady-state speed, and time constant.
%
% Function Call
% cruiseAuto_main_M4_015_19()
%
% Input Arguments
% None
%
% Output Arguments
% None
%
% Assignment Information
%   Assignment:     Cruise Auto - Main Function
%   Version:        M4
%   Team members:   Aarav Jain, jain925@purdue.edu 
%                   Abir Anajpur, aanajpur@purdue.edu 
%                   Nathan Lee, lee5698@purdue.edu 
%                   Ishaan Kedar Khambaswadkar, ikhambas@purdue.edu
%   Team ID:        015-19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
data_file = 'Sp26_cruiseAuto_newTire_raw_allTests_data.csv';

%% ____________________
%% CALCULATIONS

% 1. Import and clean data
[time_vec, speed_vec, metadata] = sub1_data_handler(data_file);

% 2. Acceleration Start Time
t_start = cruiseAuto_accel_time_SSS_TT_ikhambas(time_vec, speed_vec);

% 3. Steady State Speed
v_ss = cruiseAuto_sub4_steady_state_speeds_SSS_TT_aanajpur(time_vec, speed_vec, t_start);

% 4. Time Constant
tau = cruiseAuto_time_constant_015_19_lee5698(time_vec, speed_vec, t_start);

%% ____________________
%% FORMATTED TEXT/FIGURE DISPLAYS

fprintf('Vehicle: %s | Tire: %s\n', char(metadata.vehicle), char(metadata.tire));
fprintf('Accel Start: %.2f s\n', t_start);
fprintf('Steady-State Speed: %.2f m/s\n', v_ss);
fprintf('Time Constant (Tau): %.4f s\n', tau);

figure;
plot(time_vec, speed_vec, 'b-', 'LineWidth', 1.5);
hold on; grid on;
xline(t_start, 'r--', 'Accel Start');
xline(t_start + tau, 'g--', 'Tau (63.2%)');
yline(v_ss, 'k:', 'Steady State');
title(['Speed Response: ', char(metadata.vehicle), ' - ', char(metadata.tire)]);
xlabel('Time (s)');
ylabel('Speed (m/s)');

%% ____________________
%% RESULTS

end