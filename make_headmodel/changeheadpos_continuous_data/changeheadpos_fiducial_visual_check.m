run ~/startup.m
clear all

% Prompt user for input
subj = input('Enter the value for subj: ', 's');

% Construct the data directory path based on user input
data_dir = ['/auto/iduna/arogojin/bilateral_squeeze_test/PROC/' subj '/'];

% Load motion data from the file 'bimanualsqueeze_grandDS.dat' in the specified directory
mot = dlmread(strcat(data_dir, 'bimanualsqueeze_grandDS.dat'),' ');

% Extract relevant columns from the motion data
na = mot(:, 11)' * 100;  % Normalize and transpose column 11
le = mot(:, 12)' * 100;  % Normalize and transpose column 12
re = mot(:, 13)' * 100;  % Normalize and transpose column 13

% Compute deviations from the mean for each motion parameter
dna = na - mean(na);
dle = le - mean(le);
dre = re - mean(re);

% Calculate the length of each run and create a vector of run times
runlength = length(re) / 3;
runtimes = runlength:runlength:runlength * 2;

% Create a figure with three subplots
figure(1)

% Subplot 1: Plot the deviation of the 'na' parameter
subplot(3, 1, 1)
plot(dna);
title('Deviation of Parameter na from Mean');
xlabel('Time (samples)');
ylabel('Deviation');

% Subplot 2: Plot the deviation of the 'le' parameter
subplot(3, 1, 2)
plot(dle);
title('Deviation of Parameter le from Mean');
xlabel('Time (samples)');
ylabel('Deviation');

% Subplot 3: Plot the deviation of the 're' parameter
subplot(3, 1, 3)
plot(dre);
title('Deviation of Parameter re from Mean');
xlabel('Time (samples)');
ylabel('Deviation');

% Add vertical lines to indicate run times in all subplots
vline(runtimes);

% Note: 'vline' is not a built-in MATLAB function. Ensure you have the
% appropriate function or script that provides this functionality in your
% MATLAB environment.
