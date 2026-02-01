%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT_NAME: MATLAB_20251213_ND3_2D_Map.m
% -------------------------------------------------------------------------
% AUTHOR: SAMUEL TAKWIRIRA
% DEPARTMENT: UNH NUCLEAR PHYSICS GROUP
% DATE CREATED: 2025-11-25
% LAST MODIFIED: 2025-12-13
% VERSION: 1.0
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This script processes 2D dose distribution data (X vs Z) from a 
% Monte Carlo simulation (TOPAS) CSV file. It reshapes the 
% linear data vector into a 2D matrix and generates a highly-styled 
% heatmap visualization of the dose map in physical units (cm).
% -------------------------------------------------------------------------
% INPUTS: 
%   'ND3_2D_Map_Tests.csv' - Contains linear dose data and indices 
%                            with an 8-line header.
% OUTPUTS: 
%   Figure 1 - 2D Dose Distribution Heatmap (imagesc plot).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc; clear; close all;

%% 1. Setup
filename = '20260127ND3Map2D.csv'; 

%% 2. Automatic Header & Data Detection
% We use 'importdata' or 'readmatrix' with specific auto-detection
opts = detectImportOptions(filename, 'FileType', 'text');
opts.VariableNamingRule = 'preserve';
opts.CommentStyle = '#'; % Skips all lines starting with # regardless of where they are

% This automatically finds where the numbers start
raw_table = readtable(filename, opts);
raw_data = table2array(raw_table);

% The dose is typically the last column in TOPAS CSVs
dose_linear = raw_data(:, end);
total_points = length(dose_linear);

% Automatic Dimension Calculation
% If it's a 2D map, it's likely square. We calculate the grid based on total points.
nBins = sqrt(total_points);

if mod(nBins, 1) == 0
    nBinsX = nBins;
    nBinsZ = nBins;
else
    % If not square (e.g., 2500 points could be 50x50), we'd need to check the header
    % For now, we assume 50x50 based on your previous info
    nBinsX = 50; 
    nBinsZ = total_points / nBinsX;
end

fprintf('Successfully imported %d rows. Reshaping to [%d x %d].\n', total_points, nBinsZ, nBinsX);

%% 3. Reshape and Plot
% TOPAS usually fills Z-axis fastest (rows) then X-axis (columns)
dose_matrix = reshape(dose_linear, [nBinsZ, nBinsX]);

% Assuming standard bin widths if not parsed from header
binWidth = 0.1; 
x_axis = linspace(- (nBinsX * binWidth)/2, (nBinsX * binWidth)/2, nBinsX);
z_axis = linspace(0, nBinsZ * binWidth, nBinsZ);

figure('Color', 'w');
imagesc(x_axis, z_axis, dose_matrix);
set(gca, 'YDir', 'normal'); 
colormap('jet');

%% 4. Professional Styling
brightColor = [0, 0, 1]; % Royal Blue theme
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = brightColor;
ax.YColor = brightColor;
ax.LineWidth = 1.5;

title('2D Dose Map', 'Color', brightColor, 'FontSize', 14);
xlabel('Lateral Position X (cm)', 'Color', brightColor);
ylabel('Longitudinal Depth Z (cm)', 'Color', brightColor);

c = colorbar;
c.Color = brightColor;
ylabel(c, 'Dose (Gy)', 'Color', brightColor, 'FontWeight', 'bold');

axis equal tight; 
grid on;
ax.GridColor = brightColor; 
ax.GridAlpha = 0.2;