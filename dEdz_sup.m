clc; clear; close all;

%% 1. Parameters
filename = 'NH3_DepthDose.csv'; 
z_bin_width = 0.1;  % cm
L = 10.0;           % Total cylinder length (cm)
center_offset = L/2; 

%% 2. Import & Filter Data
raw_data = readmatrix(filename, 'NumHeaderLines', 8);
z_index = raw_data(:, 3);
dose_raw = raw_data(:, 4); 
depth_raw = (z_index * z_bin_width) + (z_bin_width / 2);

valid_idx = depth_raw <= L;
d_orig = depth_raw(valid_idx);
dose_fwd = dose_raw(valid_idx);

% Center coordinates [-5, 5]
depth_centered = d_orig - center_offset; 
dose_rev = flipud(dose_fwd); 
dose_total = dose_fwd + dose_rev;

[max_total, ~] = max(dose_total);

%% 3. 90% Zone Analysis
threshold_90 = 0.90 * max_total;
idx_90 = find(dose_total >= threshold_90);

if ~isempty(idx_90)
    z_start = depth_centered(min(idx_90));
    z_end   = depth_centered(max(idx_90));
    z_width = z_end - z_start;
    
    % --- NEW: Uniformity strictly WITHIN the 90% zone ---
    dose_in_zone = dose_total(idx_90);
    min_in_zone = min(dose_in_zone);
    max_in_zone = max(dose_in_zone);
    uniformity_zone = min_in_zone / max_in_zone;
else
    z_start = 0; z_end = 0; z_width = 0; uniformity_zone = 0;
end

%% 4. Styling & Colors
uiColor = [0, 0, 1]; colorFwd = [0.4, 0.6, 1]; 
colorRev = [1, 0.4, 0.4]; colorTotal = [0, 0.7, 0]; colorZone = [0.5, 0, 0.5];

%% 5. FIGURE
figure('Color', 'w', 'Name', 'Centered Bilateral Irradiation');
hold on;

% Plot beams
plot(depth_centered, dose_fwd, '--', 'Color', colorFwd, 'LineWidth', 1.5);
plot(depth_centered, dose_rev, ':', 'Color', colorRev, 'LineWidth', 1.5);
h3 = plot(depth_centered, dose_total, '-', 'Color', colorTotal, 'LineWidth', 3);

% 90% Zone Visuals
if z_width > 0
    % Shade the 90% region
    y_lims = [0 max_total * 1.3];
    patch([z_start z_end z_end z_start], [y_lims(1) y_lims(1) y_lims(2) y_lims(2)], ...
          [0.95 0.9 0.95], 'EdgeColor', 'none', 'FaceAlpha', 0.3, 'HandleVisibility', 'off');
    
    h4 = plot([z_start, z_end], [threshold_90, threshold_90], 'p-', 'Color', colorZone, ...
        'LineWidth', 2, 'MarkerFaceColor', colorZone, 'MarkerSize', 8);
    
    legend({'Forward Beam', 'Reverse Beam', 'Total Dose', '90% Uniformity Zone'}, 'Location', 'northeast');
end

% Formatting
grid on; ax = gca; ax.FontSize = 12; ax.FontWeight = 'bold';
xlabel('Position relative to Center (cm)'); ylabel('Dose (Gy)');
xlim([-center_offset, center_offset]); ylim(y_lims);

% Statistics Annotation Box
stats_str = { ...
    sprintf('Max Dose: %.2e Gy', max_total), ...
    sprintf('90%% Zone Width: %.2f cm', z_width), ...
    sprintf('Zone [%.2f, %.2f]', z_start, z_end), ...
    sprintf('Uniformity (Min/Max) in Zone: %.3f', uniformity_zone)};

annotation('textbox', [0.15, 0.15, 0.35, 0.18], 'String', stats_str, ...
    'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', uiColor, ...   
    'Color', uiColor, 'FontWeight', 'bold');