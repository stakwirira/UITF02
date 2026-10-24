clc; clear; close all;

%% 1. Setup
filename = '20260127ND3Map2D.csv'; 
binWidth = 0.1; % cm

%% 2. Import and Reshape
opts = detectImportOptions(filename, 'FileType', 'text');
opts.VariableNamingRule = 'preserve';
opts.CommentStyle = '#'; 
raw_table = readtable(filename, opts);
dose_linear = table2array(raw_table(:, end));

total_points = length(dose_linear);
nBinsX = 50; % Standard TOPAS X-bins
nBinsZ = total_points / nBinsX;

% Reshape: Z is usually the first dimension (rows) in TOPAS output
dose_forward = reshape(dose_linear, [nBinsZ, nBinsX]);

%% 3. Superposition Logic
% Flip the matrix along the Z-axis (rows)
dose_reverse = flipud(dose_forward);

% Total dose from both ends
dose_total = dose_forward + dose_reverse;

%% 4. Axis Definition
x_axis = linspace(-(nBinsX * binWidth)/2, (nBinsX * binWidth)/2, nBinsX);
z_axis = linspace(0, nBinsZ * binWidth, nBinsZ);

%% 5. Visualization
figure('Color', 'w', 'Name', '2D Bilateral Superposition', 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.4]);

% --- Plot Superimposed Map ---
subplot(1, 2, 1);
imagesc(x_axis, z_axis, dose_total);
set(gca, 'YDir', 'normal'); 
colormap('jet');
axis equal tight; grid on;
title('Total Superimposed Dose', 'Color', [0, 0, 1]);
xlabel('X (cm)'); ylabel('Z (cm)');
colorbar;

% --- Plot Central Axis Profile (Comparison) ---
subplot(1, 2, 2);
center_idx = round(nBinsX / 2);
hold on;
plot(z_axis, dose_forward(:, center_idx), '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
plot(z_axis, dose_total(:, center_idx), 'b-', 'LineWidth', 2);
grid on;
title('Central Axis Profile (X=0)', 'Color', [0, 0, 1]);
xlabel('Depth Z (cm)'); ylabel('Dose (Gy)');
legend('Single Entry', 'Bilateral Total');

%% 6. Styling
brightColor = [0, 0, 1];
for i = 1:2
    ax = subplot(1, 2, i);
    ax.FontSize = 11; ax.FontWeight = 'bold';
    ax.XColor = brightColor; ax.YColor = brightColor;
end