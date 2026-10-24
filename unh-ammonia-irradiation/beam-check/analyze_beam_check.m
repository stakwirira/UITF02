% ANALYZE_BEAM_CHECK  Validate the production beam against its specification.
%   Reads the phase-space file written by beam_check.txt and compares the
%   mean energy, energy spread, and spot size with the intended values
%   (PASS within 5%).
%
%   Input:  BeamResults.phsp from running TOPAS on beam_check.txt.
%   Author: Samuel B. Takwirira, UNH Nuclear Physics Group

clear; clc;

% 1. Load the PhaseSpace file
% beam_check.txt writes BeamResults.phsp (ASCII) next to BeamResults.header
filename = 'BeamResults.phsp';
data = readtable(filename, 'FileType', 'text');

% Column Mapping
% 1:X (mm), 2:Y (mm), 7:Energy (MeV)
posX = data{:, 1};
posY = data{:, 2};
energy = data{:, 7};

% 2. Statistical Verification
meanE = mean(energy);
stdE  = std(energy);
stdX  = std(posX);

% Target values for comparison:
target_meanE = 20.0;
target_stdE  = 20.0 * 0.03; % = 0.6 MeV
target_stdX  = 8.0;         % 0.8 cm = 8 mm

% 3. Print Comparison Report
fprintf('\n--- BEAM PARAMETER VALIDATION ---\n');
fprintf('PARAMETER    | EXPECTED | MEASURED | STATUS\n');
fprintf('-------------------------------------------\n');
fprintf('Mean Energy  | %8.2f | %8.2f | %s\n', target_meanE, meanE, check(meanE, target_meanE));
fprintf('Energy Sigma | %8.2f | %8.2f | %s\n', target_stdE, stdE, check(stdE, target_stdE));
fprintf('Spatial Sigma| %8.2f | %8.2f | %s\n', target_stdX, stdX, check(stdX, target_stdX));

% Plotting
figure('Color', 'w');
subplot(1,2,1);
histogram2(posX, posY, 100, 'DisplayStyle', 'tile');
axis square; title('Spatial Gaussian Profile');
xlabel('X (mm)'); ylabel('Y (mm)');

subplot(1,2,2);
histogram(energy, 100);
title('Energy Spread Spectrum');
xlabel('Energy (MeV)');

function msg = check(val, target)
    if abs(val - target)/target < 0.05, msg = 'PASS'; else, msg = 'FAIL'; end
end