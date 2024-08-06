recalculateSimulations = true;

if recalculateSimulations
    clear all;
    recalculateSimulations = true;
else
    load('knops_number_comparison.mat');
end;

omitErrorBars = true;

reference_numerosity = 16;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network, simultaneous presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations
    [proportion_greater_high] = knops_number_comparison(false, true, 0.15, false, .03, .03);
    [proportion_greater_mid] = knops_number_comparison(false, true, 0.1, false, .03, .03);
    [proportion_greater_low] = knops_number_comparison(false, true, 0.01, false, .03, .03);
end;

x = (1:size(proportion_greater_high,1)) / reference_numerosity;

% Figure for mean activation
fig_pg = figure;
set(gca,'FontSize',14);

if omitErrorBars
    plot (x, proportion_greater_low(:,1), x, proportion_greater_mid(:,1), '--', x, proportion_greater_high(:,1), ':', 'Linewidth', 2);
else
    hold on;
    errorbar (x, proportion_greater_low(:,1), proportion_greater_low(:,2), 'r-', 'Linewidth', 2);
    errorbar (x, proportion_greater_mid(:,1), proportion_greater_mid(:,2), 'b--', 'Linewidth', 2);
    errorbar (x, proportion_greater_high(:,1), proportion_greater_high(:,2), 'g:',  'Linewidth', 2);
    hold off;
end;

ylim(0:1);

title('Simultaneous presentation, noise SD = .03', 'FontSize', 20);
xlabel('Numerosity ratio', 'FontSize', 16);
ylabel('Proportion (response ''greater'')', 'FontSize', 16);
legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')

saveas(fig_pg, 'proportion_greater.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, simultaneous presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations
    [proportion_greater_high_no_noise] = knops_number_comparison(false, true, 0.15, false, 0, .03);
    [proportion_greater_mid_no_noise] = knops_number_comparison(false, true, 0.1, false, 0, .03);
    [proportion_greater_low_no_noise] = knops_number_comparison(false, true, 0.01, false, 0, .03);
end;

x = (1:size(proportion_greater_high_no_noise,1)) / reference_numerosity;

% Figure for mean activation
fig_pg_no_noise = figure;
set(gca,'FontSize',14)

if omitErrorBars
    plot (x, proportion_greater_low_no_noise(:,1), x, proportion_greater_mid_no_noise(:,1), '--', x, proportion_greater_high_no_noise(:,1), ':', 'Linewidth', 2);
else
    hold on;
    errorbar (x, proportion_greater_low_no_noise(:,1), proportion_greater_low_no_noise(:,2), 'r-', 'Linewidth', 2);
    errorbar (x, proportion_greater_mid_no_noise(:,1), proportion_greater_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
    errorbar (x, proportion_greater_high_no_noise(:,1), proportion_greater_high_no_noise(:,2), 'g:',  'Linewidth', 2);
    hold off;
end;

ylim(0:1);

title('Simultaneous presentation, noise SD = 0', 'FontSize', 20);
xlabel('Numerosity ratio',  'FontSize', 16);
ylabel('Proportion (response ''greater'')', 'FontSize', 16);
legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')

saveas(fig_pg_no_noise, 'no-noise_proportion_greater.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations
    [proportion_greater_seq_high] = knops_number_comparison(true, true, 0.15, false, .03, .03);
    [proportion_greater_seq_mid] = knops_number_comparison(true, true, 0.1, false, .03, .03);
    [proportion_greater_seq_low] = knops_number_comparison(true, true, 0.01, false, .03, .03);
end;

x = (1:size(proportion_greater_seq_high,1)) / reference_numerosity;

% Figure for mean activation
fig_pg_seq = figure;
set(gca,'FontSize',14)

if omitErrorBars
    plot (x, proportion_greater_seq_low(:,1), x, proportion_greater_seq_mid(:,1), '--', x, proportion_greater_seq_high(:,1), ':', 'Linewidth', 2);
else
    hold on;
    errorbar (x, proportion_greater_seq_low(:,1), proportion_greater_seq_low(:,2), 'r-', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq_mid(:,1), proportion_greater_seq_mid(:,2), 'b--', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq_high(:,1), proportion_greater_seq_high(:,2), 'g:',  'Linewidth', 2);
    hold off;
end;

ylim(0:1);

title('Sequential presentation, noise SD = .03', 'FontSize', 20);
xlabel('Numerosity ratio', 'FontSize', 16);
ylabel('Proportion (response ''greater'')', 'FontSize', 16);
legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')

saveas(fig_pg_seq, 'seq_proportion_greater.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations
    [proportion_greater_seq_high_no_noise] = knops_number_comparison(true, true, 0.15, false, 0, .03);
    [proportion_greater_seq_mid_no_noise] = knops_number_comparison(true, true, 0.1, false, 0, .03);
    [proportion_greater_seq_low_no_noise] = knops_number_comparison(true, true, 0.01, false, 0, .03);
end;

x = (1:size(proportion_greater_seq_high_no_noise,1)) / reference_numerosity;

% Figure for mean activation
fig_pg_seq_no_noise = figure;
set(gca,'FontSize',14)

if omitErrorBars
    plot (x, proportion_greater_seq_low_no_noise(:,1), x, proportion_greater_seq_mid_no_noise(:,1), '--', x, proportion_greater_seq_high_no_noise(:,1), ':', 'Linewidth', 2);
else
    hold on;
    errorbar (x, proportion_greater_seq_low_no_noise(:,1), proportion_greater_seq_low_no_noise(:,2), 'r-', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq_mid_no_noise(:,1), proportion_greater_seq_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq_high_no_noise(:,1), proportion_greater_seq_high_no_noise(:,2), 'g:',  'Linewidth', 2);
    hold off;
end;

ylim(0:1);

title('Sequential presentation, noise SD = 0', 'FontSize', 20);
xlabel('Numerosity ratio',  'FontSize', 16);
ylabel('Proportion (response ''greater'')', 'FontSize', 16);
legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')

saveas(fig_pg_seq_no_noise, 'seq_no-noise_proportion_greater.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%% NO WAITING PERIOD BETWEEN PRESENTATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations
    [proportion_greater_seq2_high] = knops_number_comparison(true, false, 0.15, false, .03, .03);
    [proportion_greater_seq2_mid] = knops_number_comparison(true, false, 0.1, false, .03, .03);
    [proportion_greater_seq2_low] = knops_number_comparison(true, false, 0.01, false, .03, .03);
end;

x = (1:size(proportion_greater_seq2_high,1)) / reference_numerosity;

% Figure for mean activation
fig_pg_seq2 = figure;
set(gca,'FontSize',14)

if omitErrorBars
    plot (x, proportion_greater_seq2_low(:,1), x, proportion_greater_seq2_mid(:,1), '--', x, proportion_greater_seq2_high(:,1), ':', 'Linewidth', 2);
else
    hold on;
    errorbar (x, proportion_greater_seq2_low(:,1), proportion_greater_seq2_low(:,2), 'r-', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq2_mid(:,1), proportion_greater_seq2_mid(:,2), 'b--', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq2_high(:,1), proportion_greater_seq2_high(:,2), 'g:',  'Linewidth', 2);
    hold off;
end;

ylim(0:1);

title('Sequential presentation (continuous), noise SD = .03', 'FontSize', 18);
xlabel('Numerosity ratio', 'FontSize', 16);
ylabel('Proportion (response ''greater'')', 'FontSize', 16);
legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')

saveas(fig_pg_seq2, 'seq2_proportion_greater.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculateSimulations
    [proportion_greater_seq2_high_no_noise] = knops_number_comparison(true, false, 0.15, false, 0, .03);
    [proportion_greater_seq2_mid_no_noise] = knops_number_comparison(true, false, 0.1, false, 0, .03);
    [proportion_greater_seq2_low_no_noise] = knops_number_comparison(true, false, 0.01, false, 0, .03);
end;

x = (1:size(proportion_greater_seq2_high_no_noise,1)) / reference_numerosity;

% Figure for mean activation
fig_pg_seq2_no_noise = figure;
set(gca,'FontSize',14)

if omitErrorBars
    plot (x, proportion_greater_seq2_low_no_noise(:,1), x, proportion_greater_seq2_mid_no_noise(:,1), '--', x, proportion_greater_seq2_high_no_noise(:,1), ':', 'Linewidth', 2);
    line([(reference_numerosity-1)/reference_numerosity (reference_numerosity-1)/reference_numerosity], [0 .2]);
    line([(reference_numerosity+1)/reference_numerosity (reference_numerosity+1)/reference_numerosity], [0 .2]);
else
    hold on;
    errorbar (x, proportion_greater_seq2_low_no_noise(:,1), proportion_greater_seq2_low_no_noise(:,2), 'r-', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq2_mid_no_noise(:,1), proportion_greater_seq2_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
    errorbar (x, proportion_greater_seq2_high_no_noise(:,1), proportion_greater_seq2_high_no_noise(:,2), 'g:',  'Linewidth', 2);
    hold off;
end;

ylim(0:1);

title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
xlabel('Numerosity ratio',  'FontSize', 16);
ylabel('Proportion (response ''greater'')', 'FontSize', 16);
legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')

saveas(fig_pg_seq2_no_noise, 'seq2_no-noise_proportion_greater.png');

if recalculateSimulations
    save('knops_number_comparison.mat');
end;
