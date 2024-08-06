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
    recalculateSimulations_contents = true;
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
    [mean_act_seq_15, faith_seq_15, inhibition_seq_sum_15] = knops(true, true, 0.15, false, .03, .03);
    [mean_act_seq_10, faith_seq_10, inhibition_seq_sum_10] = knops(true, true, 0.1, false, .03, .03);
end;

[mean_activation, faithfulness, activation_in_early_and_late_targets, ...
 inhibition_sum, n_active_neurons, mean_activation_in_active_neurons, ...
 dprime, bbeta] 
, dprime_, bbeta_
if recalculateSimulations_contents
    [mean_act_seq_content_20, faith_seq_content_20, activation_in_early_and_late_targets_seq_content_20, inhibition_seq_content_sum_20, n_active_neurons_seq_20, mean_activation_in_active_neurons_seq_20, dprime_20, bbeta_20] = knops_track_memory_contents_and_number_of_activated_units(true, true, 0.20, false, .03, .03);
    [mean_act_seq_content_15, faith_seq_content_15, activation_in_early_and_late_targets_seq_content_15, inhibition_seq_content_sum_15, n_active_neurons_seq_15, mean_activation_in_active_neurons_seq_15] = knops_track_memory_contents_and_number_of_activated_units(true, true, 0.15, false, .03, .03);
    [mean_act_seq_content_10, faith_seq_content_10, activation_in_early_and_late_targets_seq_content_10, inhibition_seq_content_sum_10, n_active_neurons_seq_10, mean_activation_in_active_neurons_seq_10] = knops_track_memory_contents_and_number_of_activated_units(true, true, 0.1, false, .03, .03);
end;

% Figure for number of active neurons
fig_n_active_seq = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq_high);
xoffset_10 =  max(x) - length(n_active_neurons_seq_10) + 1;
xoffset_15 =  max(x) - length(n_active_neurons_seq_15) + 1;
xoffset_20 =  max(x) - length(n_active_neurons_seq_20) + 1;

plot (x(xoffset_10:end), n_active_neurons_seq_10(:,1), ...
    x(xoffset_15:end), n_active_neurons_seq_15(:,1), '--', ...
    x(xoffset_20:end), n_active_neurons_seq_20(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation, noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Number of active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_n_active_seq, 'seq_n_active.png');


% figure for activity in active neurons

fig_ma_in_active_seq = figure;
set(gca,'FontSize',14)

plot (x(xoffset_10:end), mean_activation_in_active_neurons_seq_10(:,1), ...
    x(xoffset_15:end), mean_activation_in_active_neurons_seq_15(:,1), '--', ...
    x(xoffset_20:end), mean_activation_in_active_neurons_seq_20(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation, noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation in active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_ma_in_active_seq, 'seq_ma_in_active.png');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq_15_no_noise, faith_seq_15_no_noise, inhibition_seq_sum_15_no_noise] = knops(true, true, 0.15, false, 0, .03);
    [mean_act_seq_10_no_noise, faith_seq_10_no_noise, inhibition_seq_sum_10_no_noise] = knops(true, true, 0.1, false, 0, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq_content_20_no_noise, faith_seq_content_20_no_noise, activation_in_early_and_late_targets_seq_content_20_no_noise, inhibition_seq_content_sum_20_no_noise, n_active_neurons_seq_20_no_noise, mean_activation_in_active_neurons_seq_20_no_noise] = knops_track_memory_contents_and_number_of_activated_units(true, true, 0.20, false, 0, .03);
    [mean_act_seq_content_15_no_noise, faith_seq_content_15_no_noise, activation_in_early_and_late_targets_seq_content_15_no_noise, inhibition_seq_content_sum_15_no_noise, n_active_neurons_seq_15_no_noise, mean_activation_in_active_neurons_seq_15_no_noise] = knops_track_memory_contents_and_number_of_activated_units(true, true, 0.15, false, 0, .03);
    [mean_act_seq_content_10_no_noise, faith_seq_content_10_no_noise, activation_in_early_and_late_targets_seq_content_10_no_noise, inhibition_seq_content_sum_10_no_noise, n_active_neurons_seq_10_no_noise, mean_activation_in_active_neurons_seq_10_no_noise] = knops_track_memory_contents_and_number_of_activated_units(true, true, 0.1, false, 0, .03);
end;

% Figure for number of active neurons
fig_n_active_seq_no_noise = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq_high);
xoffset_10 =  max(x) - length(n_active_neurons_seq_10_no_noise) + 1;
xoffset_15 =  max(x) - length(n_active_neurons_seq_15_no_noise) + 1;
xoffset_20 =  max(x) - length(n_active_neurons_seq_20_no_noise) + 1;

plot (x(xoffset_10:end), n_active_neurons_seq_10_no_noise(:,1), ...
    x(xoffset_15:end), n_active_neurons_seq_15_no_noise(:,1), '--', ...
    x(xoffset_20:end), n_active_neurons_seq_20_no_noise(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation, noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Number of active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_n_active_seq_no_noise, 'seq_no_noise_n_active.png');


% figure for activity in active neurons

fig_ma_in_active_seq_no_noise = figure;
set(gca,'FontSize',14)

plot (x(xoffset_10:end), mean_activation_in_active_neurons_seq_10_no_noise(:,1), ...
    x(xoffset_15:end), mean_activation_in_active_neurons_seq_15_no_noise(:,1), '--', ...
    x(xoffset_20:end), mean_activation_in_active_neurons_seq_20_no_noise(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation, noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation in active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_ma_in_active_seq_no_noise, 'seq_no_noise_ma_in_active.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%% NO WAITING PERIOD BETWEEN PRESENTATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq2_15, faith_seq2_15, inhibition_seq2_sum_15] = knops(true, false, 0.15, false, .03, .03);
    [mean_act_seq2_10, faith_seq2_10, inhibition_seq2_sum_10] = knops(true, false, 0.1, false, .03, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq2_content_20, faith_seq2_content_20, activation_in_early_and_late_targets_seq2_content_20, inhibition_seq2_content_sum_20, n_active_neurons_seq2_20, mean_activation_in_active_neurons_seq2_20] = knops_track_memory_contents_and_number_of_activated_units(true, false, 0.20, false, .03, .03);
    [mean_act_seq2_content_15, faith_seq2_content_15, activation_in_early_and_late_targets_seq2_content_15, inhibition_seq2_content_sum_15, n_active_neurons_seq2_15, mean_activation_in_active_neurons_seq2_15] = knops_track_memory_contents_and_number_of_activated_units(true, false, 0.15, false, .03, .03);
    [mean_act_seq2_content_10, faith_seq2_content_10, activation_in_early_and_late_targets_seq2_content_10, inhibition_seq2_content_sum_10, n_active_neurons_seq2_10, mean_activation_in_active_neurons_seq2_10] = knops_track_memory_contents_and_number_of_activated_units(true, false, 0.1, false, .03, .03);
end;

% Figure for mean activity of active neurons
fig_n_active_seq2 = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq2_high);
xoffset_10 =  max(x) - length(n_active_neurons_seq2_10) + 1;
xoffset_15 =  max(x) - length(n_active_neurons_seq2_15) + 1;
xoffset_20 =  max(x) - length(n_active_neurons_seq2_20) + 1;

plot (x(xoffset_10:end), n_active_neurons_seq2_10(:,1), ...
    x(xoffset_15:end), n_active_neurons_seq2_15(:,1), '--', ...
    x(xoffset_20:end), n_active_neurons_seq2_20(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation  (continuous), noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Number of active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_n_active_seq2, 'seq2_n_active.png');


% figure for number of active neurons

fig_ma_in_active_seq2 = figure;
set(gca,'FontSize',14)

plot (x(xoffset_10:end), mean_activation_in_active_neurons_seq2_10(:,1), ...
    x(xoffset_15:end), mean_activation_in_active_neurons_seq2_15(:,1), '--', ...
    x(xoffset_20:end), mean_activation_in_active_neurons_seq2_20(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation  (continuous), noise SD = .03', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation in active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_ma_in_active_seq2, 'seq2_ma_in_active.png');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations_overall
    [mean_act_seq2_15_no_noise, faith_seq2_15_no_noise, inhibition_seq2_sum_15_no_noise] = knops(true, false, 0.15, false, 0, .03);
    [mean_act_seq2_10_no_noise, faith_seq2_10_no_noise, inhibition_seq2_sum_10_no_noise] = knops(true, false, 0.1, false, 0, .03);
end;

if recalculateSimulations_contents
    [mean_act_seq2_content_20_no_noise, faith_seq2_content_20_no_noise, activation_in_early_and_late_targets_seq2_content_20_no_noise, inhibition_seq2_content_sum_20_no_noise, n_active_neurons_seq2_20_no_noise, mean_activation_in_active_neurons_seq2_20_no_noise] = knops_track_memory_contents_and_number_of_activated_units(true, false, 0.20, false, 0, .03);
    [mean_act_seq2_content_15_no_noise, faith_seq2_content_15_no_noise, activation_in_early_and_late_targets_seq2_content_15_no_noise, inhibition_seq2_content_sum_15_no_noise, n_active_neurons_seq2_15_no_noise, mean_activation_in_active_neurons_seq2_15_no_noise] = knops_track_memory_contents_and_number_of_activated_units(true, false, 0.15, false, 0, .03);
    [mean_act_seq2_content_10_no_noise, faith_seq2_content_10_no_noise, activation_in_early_and_late_targets_seq2_content_10_no_noise, inhibition_seq2_content_sum_10_no_noise, n_active_neurons_seq2_10_no_noise, mean_activation_in_active_neurons_seq2_10_no_noise] = knops_track_memory_contents_and_number_of_activated_units(true, false, 0.1, false, 0, .03);
end;

% Figure for mean activity of active neurons
fig_n_active_seq2_no_noise = figure;
set(gca,'FontSize',14)

x = 1:length(mean_act_seq2_high);
xoffset_10 =  max(x) - length(n_active_neurons_seq2_10_no_noise) + 1;
xoffset_15 =  max(x) - length(n_active_neurons_seq2_15_no_noise) + 1;
xoffset_20 =  max(x) - length(n_active_neurons_seq2_20_no_noise) + 1;

plot (x(xoffset_10:end), n_active_neurons_seq2_10_no_noise(:,1), ...
    x(xoffset_15:end), n_active_neurons_seq2_15_no_noise(:,1), '--', ...
    x(xoffset_20:end), n_active_neurons_seq2_20_no_noise(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Number of active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_n_active_seq2_no_noise, 'seq2_no_noise_n_active.png');


% figure for number of active neurons

fig_ma_in_active_seq2_no_noise = figure;
set(gca,'FontSize',14)

plot (x(xoffset_10:end), mean_activation_in_active_neurons_seq2_10_no_noise(:,1), ...
    x(xoffset_15:end), mean_activation_in_active_neurons_seq2_15_no_noise(:,1), '--', ...
    x(xoffset_20:end), mean_activation_in_active_neurons_seq2_20_no_noise(:,1), ':', ...
    'Linewidth', 2);

title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
xlabel('Set size', 'FontSize', 16);
ylabel('Mean activation in active neurons', 'FontSize', 16);
legend('b = .1', 'b = .15', 'b = .2', 'Location','east')

saveas(fig_ma_in_active_seq2_no_noise, 'seq2_no_noise_ma_in_active.png');

