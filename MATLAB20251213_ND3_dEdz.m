%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT_NAME: MATLAB20251213_ND3_dEdz.m
% -------------------------------------------------------------------------
% AUTHOR: SAMUEL TAKWIRIRA
% DEPARTMENT: UNH NUCLEAR PHYSICS GROUP
% DATE CREATED: 2025-11-25
% LAST MODIFIED: 2025-12-13
% VERSION: 1.0
% -------------------------------------------------------------------------
% DESCRIPTION: 
% 
% -------------------------------------------------------------------------
% INPUTS: CSV
%   '- Contains linear dose data and indices 
%                            with an 8-line header'.
% OUTPUTS: 
%   Figure 1 - 2D Dose Distribution Heatmap (imagesc plot).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% 1. Parameters
filename = '20260127ND3dEdz.csv'; 
z_bin_width = 0.1; % cm (From the header: "# Z in 100 bins of 0.1 cm")

%% 2. Import Data
try
    raw_data = readmatrix(filename, 'NumHeaderLines', 8);
catch
    error('File not found. Make sure "%s" is in the current folder.', filename);
end

%% 3. Extract and Process Data
z_index = raw_data(:, 3);
dose_values = raw_data(:, 4);
depth_cm = (z_index * z_bin_width) + (z_bin_width / 2);

% Calculations for annotations
[max_dose, max_idx] = max(dose_values);
peak_depth = depth_cm(max_idx);

% Normalization (0 to 1 scale)
norm_dose = dose_values / max_dose;

%% 4. Styling Definitions
uiColor = [0, 0, 1];    % Blue for UI elements
lineColor = [0, 0.7, 0]; % Green for the data line

%% 5. FIGURE 1: Absolute Dose (Gy)
figure('Color', 'w', 'Name', 'Absolute Dose Profile');
plot(depth_cm, dose_values, '-', 'Color', lineColor, 'LineWidth', 2);                

ax1 = gca;
ax1.FontSize = 12;
ax1.FontWeight = 'bold';
ax1.LineWidth = 1.5;
ax1.XColor = uiColor;    
ax1.YColor = uiColor;    
ax1.GridColor = uiColor; 
ax1.GridAlpha = 0.2;         

title('Longitudinal Depth Dose Profile (Absolute)', 'Color', uiColor, 'FontSize', 14);
xlabel('Depth Z (cm)', 'Color', uiColor, 'FontWeight', 'bold');
ylabel('Dose (Gy)', 'Color', uiColor, 'FontWeight', 'bold');
grid on;
xlim([min(depth_cm) max(depth_cm)]);

stats_str1 = sprintf('Peak Dose: %.2e Gy\nAt Depth: %.1f cm', max_dose, peak_depth);
annotation('textbox', [0.6, 0.75, 0.1, 0.1], 'String', stats_str1, ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', uiColor, ...   
    'Color', uiColor, 'FontWeight', 'bold', 'LineWidth', 1);

%% 6. FIGURE 2: Normalized Dose (0 to 1)
figure('Color', 'w', 'Name', 'Normalized Dose Profile');
plot(depth_cm, norm_dose, '-', 'Color', lineColor, 'LineWidth', 2);                

ax2 = gca;
ax2.FontSize = 12;
ax2.FontWeight = 'bold';
ax2.LineWidth = 1.5;
ax2.XColor = uiColor;    
ax2.YColor = uiColor;    
ax2.GridColor = uiColor; 
ax2.GridAlpha = 0.2;         

title('Normalized Longitudinal Depth Dose (Scale 0-1)', 'Color', uiColor, 'FontSize', 14);
xlabel('Depth Z (cm)', 'Color', uiColor, 'FontWeight', 'bold');
ylabel('Normalized Dose (D/D_{max})', 'Color', uiColor, 'FontWeight', 'bold');
grid on;
xlim([min(depth_cm) max(depth_cm)]);
ylim([0 1.1]); % Extra room at the top

stats_str2 = sprintf('Normalized to D_{max}\nPeak Depth: %.1f cm', peak_depth);
annotation('textbox', [0.6, 0.75, 0.1, 0.1], 'String', stats_str2, ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', uiColor, ...   
    'Color', uiColor, 'FontWeight', 'bold', 'LineWidth', 1);