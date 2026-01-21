%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT_NAME: ND3_2D_Map_Tests.m
% -------------------------------------------------------------------------
% AUTHOR: SAMUEL KHUMBULA
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
%% 1. Setup Parameters
filename = 'ND3_2D_Map_121325.csv'; % Needs to match
% Based on the header in your image:
nBinsX = 50;
nBinsZ = 50;
binWidthX = 0.1; % cm
binWidthZ = 0.2; % cm
%% 2. Import Data (Skipping first 8 header rows)
% The file structure is: [x_index, y_index, z_index, DoseValue]
try
    raw_data = readmatrix(filename, 'NumHeaderLines', 8);
catch
    error('File not found. Please ensure the CSV file is in the current folder.');
end
% Extract the Dose column (Column 4)
dose_linear = raw_data(:, 4);
% Check if we have the expected number of data points
if length(dose_linear) ~= (nBinsX * nBinsZ)
    warning('Data length (%d) does not match expected dimensions (%d). Check bin settings.', length(dose_linear), nBinsX*nBinsZ);
end
%% 3. Reshape Data for Plotting
% TOPAS typically iterates Z fastest, then Y, then X. 
% We need to reshape the linear vector into a 2D matrix.
dose_matrix = reshape(dose_linear, [nBinsZ, nBinsX]);
% Define physical axis (Centering X, starting Z at 0)
x_axis = linspace(- (nBinsX * binWidthX)/2, (nBinsX * binWidthX)/2, nBinsX);
z_axis = linspace(0, nBinsZ * binWidthZ, nBinsZ);
%% 4. Plot Heatmap (imagesc)
figure('Color', 'w'); % Keeps background white
% We use x_axis and z_axis to show real units (cm) instead of just indices
imagesc(x_axis, z_axis, dose_matrix);
% --- START: COLOR STYLING ---
% Define color here (RGB Format)
% [0 0 1] is Bright Blue. Change to [1 0 0] for Red, [1 0 1] for Magenta.
brightColor = [0, 0, 1]; 
set(gca, 'YDir', 'normal'); % Standard plot direction 
colormap('jet');            % 'jet', 'parula', or 'hot' look best for dose
% Configure Axes and Ticks to be Bright
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';     % Bold makes the color pop more
ax.XColor = brightColor;    % Changes X axis line and numbers
ax.YColor = brightColor;    % Changes Y axis line and numbers
ax.LineWidth = 1.5;         % Thicker axis lines
% Configure Titles and Labels to be Bright
title('2D Dose Distribution Map (X vs Z)', 'Color', brightColor, 'FontSize', 14);
xlabel('Lateral Position X (cm)', 'Color', brightColor, 'FontWeight', 'bold');
ylabel('Longitudinal Depth Z (cm)', 'Color', brightColor, 'FontWeight', 'bold');
% Configure Colorbar to be Bright
c = colorbar;
c.Color = brightColor;           % Changes the tick numbers on the bar
c.Label.String = 'Dose (Gy)';
c.Label.Color = brightColor;     % Changes the label text
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';
% --- END: COLOR STYLING ---
% Aesthetics
axis equal tight; 
grid on;
% Change grid color to a lighter version of the bright color if desired, 
% or keep it gray for contrast against the data.
ax.GridColor = brightColor; 
ax.GridAlpha = 0.3; % Transparency of grid