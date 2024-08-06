%clear all;
recalculateSimulations_overall = false;
recalculateSimulations_contents = true;

if recalculateSimulations_overall
    clear all;
    recalculateSimulations_overall = true;
    recalculateSimulations_contents = true;
else
    load('knops.mat');
    recalculateSimulations_overall = false;
    recalculateSimulations_contents = false;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq_high, faith_seq_high, inhibition_seq_sum_high] = knops(true, true, 0.15, false, .03, .03);
    [mean_act_seq_mid, faith_seq_mid, inhibition_seq_sum_mid] = knops(true, true, 0.1, false, .03, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq_content_high, faith_seq_content_high, activation_in_early_and_late_targets_seq_content_high, inhibition_seq_content_sum_high] = knops_track_memory_contents(true, true, 0.15, false, .03, .03);
    [mean_act_seq_content_mid, faith_seq_content_mid, activation_in_early_and_late_targets_seq_content_mid, inhibition_seq_content_sum_mid] = knops_track_memory_contents(true, true, 0.1, false, .03, .03);
end;

% Figure for mean activation
% we need separate figures for high and mid
fig_ma_seq_content_high = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq_content_high);
xoffset =  length(mean_act_seq_high) - length(mean_act_seq_content_high);

plot (xoffset + x, mean_act_seq_content_high(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_high(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_high(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation, b = .15, noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq_content_high, 'seq_content_high.png');

% figure for mid

x = 1:length(mean_act_seq_content_mid);
xoffset =  length(mean_act_seq_mid) - length(mean_act_seq_content_mid);

fig_ma_seq_content_mid = figure;
set(gca,'FontSize',14)

plot (xoffset + x, mean_act_seq_content_mid(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_mid(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_mid(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation, b = .1, noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq_content_mid, 'seq_content_mid.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq_high_no_noise, faith_seq_high_no_noise, inhibition_seq_sum_high_no_noise] = knops(true, true, 0.15, false, 0, .03);
    [mean_act_seq_mid_no_noise, faith_seq_mid_no_noise, inhibition_seq_sum_mid_no_noise] = knops(true, true, 0.1, false, 0, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq_content_high_no_noise, faith_seq_content_high_no_noise, activation_in_early_and_late_targets_seq_content_high_no_noise, inhibition_seq_content_sum_high_no_noise] = knops_track_memory_contents(true, true, 0.15, false, 0, .03);
    [mean_act_seq_content_mid_no_noise, faith_seq_content_mid_no_noise, activation_in_early_and_late_targets_seq_content_mid_no_noise, inhibition_seq_content_sum_mid_no_noise] = knops_track_memory_contents(true, true, 0.1, false, 0, .03);
end;

% Figure for mean activation
% we need separate figures for high and mid
fig_ma_seq_content_high_no_noise = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq_content_high_no_noise);
xoffset =  length(mean_act_seq_high_no_noise) - length(mean_act_seq_content_high_no_noise);

plot (xoffset + x, mean_act_seq_content_high_no_noise(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_high_no_noise(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_high_no_noise(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation, b = .15, noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq_content_high_no_noise, 'seq_content_high_no_noise.png');

% figure for mid
fig_ma_seq_content_mid_no_noise = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq_content_mid_no_noise);
xoffset =  length(mean_act_seq_mid_no_noise) - length(mean_act_seq_content_mid_no_noise);

plot (xoffset + x, mean_act_seq_content_mid_no_noise(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_mid_no_noise(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq_content_mid_no_noise(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation, b = .1, noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq_content_mid_no_noise, 'seq_content_mid_no_noise.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%% NO WAITING PERIOD BETWEEN PRESENTATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq2_high, faith_seq2_high, inhibition_seq2_sum_high] = knops(true, false, 0.15, false, .03, .03);
    [mean_act_seq2_mid, faith_seq2_mid, inhibition_seq2_sum_mid] = knops(true, false, 0.1, false, .03, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq2_content_high, faith_seq2_content_high, activation_in_early_and_late_targets_seq2_content_high, inhibition_seq2_content_sum_high] = knops_track_memory_contents(true, false, 0.15, false, .03, .03);
    [mean_act_seq2_content_mid, faith_seq2_content_mid, activation_in_early_and_late_targets_seq2_content_mid, inhibition_seq2_content_sum_mid] = knops_track_memory_contents(true, false, 0.1, false, .03, .03);
end;

% Figure for mean activation
% we need separate figures for high and mid
fig_ma_seq2_content_high = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq2_content_high);
xoffset =  length(mean_act_seq2_high) - length(mean_act_seq2_content_high);

plot (xoffset + x, mean_act_seq2_content_high(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_high(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_high(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation (continuous), b = .15, noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq2_content_high, 'seq2_content_high.png');

% figure for mid
fig_ma_seq2_content_mid = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq2_content_mid);
xoffset =  length(mean_act_seq2_mid) - length(mean_act_seq2_content_mid);

plot (xoffset + x, mean_act_seq2_content_mid(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_mid(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_mid(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation (continuous), b = .1, noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq2_content_mid, 'seq2_content_mid.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq2_high_no_noise, faith_seq2_high_no_noise, inhibition_seq2_sum_high_no_noise] = knops(true, false, 0.15, false, 0, .03);
    [mean_act_seq2_mid_no_noise, faith_seq2_mid_no_noise, inhibition_seq2_sum_mid_no_noise] = knops(true, false, 0.1, false, 0, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq2_content_high_no_noise, faith_seq2_content_high_no_noise, activation_in_early_and_late_targets_seq2_content_high_no_noise, inhibition_seq2_content_sum_high_no_noise] = knops_track_memory_contents(true, false, 0.15, false, 0, .03);
    [mean_act_seq2_content_mid_no_noise, faith_seq2_content_mid_no_noise, activation_in_early_and_late_targets_seq2_content_mid_no_noise, inhibition_seq2_content_sum_mid_no_noise] = knops_track_memory_contents(true, false, 0.1, false, 0, .03);
end;

% Figure for mean activation
% we need separate figures for high and mid
fig_ma_seq2_content_high_no_noise = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq2_content_high_no_noise);
xoffset =  length(mean_act_seq2_high_no_noise) - length(mean_act_seq2_content_high_no_noise);

plot (xoffset + x, mean_act_seq2_content_high_no_noise(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_high_no_noise(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_high_no_noise(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation (continuous), b = .15, noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq2_content_high_no_noise, 'seq2_content_high_no_noise.png');

% figure for mid
fig_ma_seq2_content_mid_no_noise = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq2_content_mid_no_noise);
xoffset =  length(mean_act_seq2_mid_no_noise) - length(mean_act_seq2_content_mid_no_noise);

plot (xoffset + x, mean_act_seq2_content_mid_no_noise(:,1), ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_mid_no_noise(:,1), '--', ...
    xoffset + x, activation_in_early_and_late_targets_seq2_content_mid_no_noise(:,3), ':', ...
    'Linewidth', 2);

title('Sequential presentation (continuous), b = .1, noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation', 'FontSize', 16);
legend('overall', 'early', 'late', 'Location','east')

saveas(fig_ma_seq2_content_mid_no_noise, 'seq2_content_mid_no_noise.png');

