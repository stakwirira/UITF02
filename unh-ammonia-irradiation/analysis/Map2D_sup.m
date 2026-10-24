clc; clear; close all;

%% 1. Setup & Import
filename = 'NH3_2D_Map.csv'; 
binWidth = 0.1; 

opts = detectImportOptions(filename, 'FileType', 'text');
opts.CommentStyle = '#'; 
raw_table = readtable(filename, opts);
dose_linear = table2array(raw_table(:, end));

nBinsX = 50; 
nBinsZ = length(dose_linear) / nBinsX;
dose_forward = reshape(dose_linear, [nBinsZ, nBinsX]);

%% 2. Superposition Logic
dose_reverse = flipud(dose_forward);
dose_total = dose_forward + dose_reverse;

% Axis Definition
x_axis = linspace(-(nBinsX * binWidth)/2, (nBinsX * binWidth)/2, nBinsX);
z_axis = linspace(0, nBinsZ * binWidth, nBinsZ);

%% 3. Lateral Slice Logic (90 degrees to beam)
% We take the slice at the midpoint of the cylinder's length (Z-center)
mid_z_idx = round(nBinsZ / 2);
prof_lat_total = dose_total(mid_z_idx, :); 
prof_lat_fwd   = dose_forward(mid_z_idx, :);
prof_lat_rev   = dose_reverse(mid_z_idx, :);

% 90% Uniformity Calculation for Lateral Width
max_lat = max(prof_lat_total);
threshold = 0.90 * max_lat;
idx_region = find(prof_lat_total >= threshold);
x_start = x_axis(min(idx_region));
x_end = x_axis(max(idx_region));
x_width = x_end - x_start;

%% 4. Visualization
figure('Color', 'w', 'Units', 'normalized', 'Position', [0.05, 0.1, 0.9, 0.8]);
t = tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
uiColor = [0, 0, 1];

% --- TOP ROW: 2D Maps ---
nexttile; imagesc(x_axis, z_axis, dose_forward); title('Entry A (Forward)');
ylabel('Depth Z (cm)'); set(gca, 'YDir', 'normal'); axis equal tight;

nexttile; imagesc(x_axis, z_axis, dose_reverse); title('Entry B (Reverse)');
set(gca, 'YDir', 'normal', 'YTickLabel', []); axis equal tight;

nexttile; imagesc(x_axis, z_axis, dose_total); title('Total Superimposed');
set(gca, 'YDir', 'normal', 'YTickLabel', []); axis equal tight;
colormap('jet'); cb = colorbar; ylabel(cb, 'Dose (Gy)');

% --- BOTTOM ROW: Lateral Profile (90 deg to Z) ---
nexttile([1, 3]);
hold on;

% Plot Lateral Components
plot(x_axis, prof_lat_fwd, '--', 'Color', [0.4, 0.6, 1], 'LineWidth', 1, 'DisplayName', 'Forward (at Z-mid)');
plot(x_axis, prof_lat_rev, ':', 'Color', [1, 0.4, 0.4], 'LineWidth', 1, 'DisplayName', 'Reverse (at Z-mid)');
plot(x_axis, prof_lat_total, '-', 'Color', [0, 0.7, 0], 'LineWidth', 3, 'DisplayName', 'Total Lateral Dose');

% Horizontal Dimension Line for Width
plot([x_start, x_end], [threshold, threshold], 'p-', 'Color', [0.5, 0, 0.5], ...
    'LineWidth', 2, 'MarkerFaceColor', [0.5, 0, 0.5], 'MarkerSize', 8, ...
    'DisplayName', sprintf('90%% Lateral Width: %.2f cm', x_width));

% Vertical Indicators
xline(x_start, '--', 'Color', [0.5, 0, 0.5], 'HandleVisibility', 'off');
xline(x_end, '--', 'Color', [0.5, 0, 0.5], 'HandleVisibility', 'off');

grid on;
title(sprintf('Lateral Dose Distribution (at Z = %.1f cm)', z_axis(mid_z_idx)), 'Color', uiColor);
xlabel('Lateral Position X (cm)'); ylabel('Dose (Gy)');
legend('Location', 'northeast');
ylim([0 max_lat * 1.2]);

% Styling
set(findall(gcf,'type','axes'), 'FontSize', 11, 'FontWeight', 'bold', ...
    'XColor', uiColor, 'YColor', uiColor, 'LineWidth', 1.2);