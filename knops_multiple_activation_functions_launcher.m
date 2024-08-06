clear all;
recalculateSimulations = true;

if recalculateSimulations
    clear all;
    recalculateSimulations = true;
else
    load('knops_multiple_activation_functions.mat');
end;

addpath('helper_functions');

omitErrorBars = true;
printLegend = false;
printTitle = false;
saveFigures = true;
includeNearestNeighborNetwork = false;

all_act_fnc = {'knops', 'threshold', 'linear', 'sigmoid', 'relu', 'tanh'};

for act_fnc_ind = 1:length(all_act_fnc)
    
    actFncName = all_act_fnc{act_fnc_ind};
    actFncParam = nan;
    actFncText = get_act_fnc_equation_text(actFncName);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with fully connected network, simultaneous presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if recalculateSimulations
        [mean_act_high, faith_high, inhibition_sum_high] = knops_multiple_activation_functions(false, true, 0.15, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_mid, faith_mid, inhibition_sum_mid] = knops_multiple_activation_functions(false, true, 0.1, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_low, faith_low, inhibition_sum_low] = knops_multiple_activation_functions(false, true, 0.01, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
    end;
    
    x = 1:length(mean_act_high);
    
    % Figure for mean activation
    fig_ma = figure;
    set(gca,'FontSize',14);
    
    if omitErrorBars
        plot (x, mean_act_low(:,1), x, mean_act_mid(:,1), '--', x, mean_act_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, mean_act_low(:,1), mean_act_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, mean_act_mid(:,1), mean_act_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, mean_act_high(:,1), mean_act_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Simultaneous presentation, noise SD = .03', 'FontSize', 20);
    end;
    xlabel('Set size', 'FontSize', 16);
    ylabel('Mean activation', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_ma, 'mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for Faithfullness
    fig_faith = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, 1-faith_low(:,1), x, 1-faith_mid(:,1), '--', x, 1-faith_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, 1-faith_low(:,1), 1-faith_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, 1-faith_mid(:,1), 1-faith_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, 1-faith_high(:,1), 1-faith_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    if printTitle
        title('Simultaneous presentation, noise SD = .03', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Proportion correct', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_faith, 'faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for mean inhibition in network
    fig_inhibition = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, -inhibition_sum_low(:,1), x, -inhibition_sum_mid(:,1), '--', x, -inhibition_sum_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, -inhibition_sum_low(:,1), -inhibition_sum_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, -inhibition_sum_mid(:,1), -inhibition_sum_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, -inhibition_sum_high(:,1), -inhibition_sum_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    if printTitle
        title('Simultaneous presentation, noise SD = .03', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean inhibition', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_inhibition, 'inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with fully connected network but no noise, simultaneous presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if recalculateSimulations
        [mean_act_high_no_noise, faith_high_no_noise, inhibition_sum_high_no_noise] = knops_multiple_activation_functions(false, true, 0.15, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_mid_no_noise, faith_mid_no_noise, inhibition_sum_mid_no_noise] = knops_multiple_activation_functions(false, true, 0.1, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_low_no_noise, faith_low_no_noise, inhibition_sum_low_no_noise] = knops_multiple_activation_functions(false, true, 0.01, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
    end;
    
    x = 1:length(mean_act_high_no_noise);
    
    % Figure for mean activation
    fig_ma_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, mean_act_low_no_noise(:,1), x, mean_act_mid_no_noise(:,1), '--', x, mean_act_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, mean_act_low_no_noise(:,1), mean_act_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, mean_act_mid_no_noise(:,1), mean_act_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, mean_act_high_no_noise(:,1), mean_act_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Simultaneous presentation, noise SD = 0', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean activation', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_ma_no_noise, 'no-noise_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for Faithfullness
    fig_faith_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, 1-faith_low_no_noise(:,1), x, 1-faith_mid_no_noise(:,1), '--', x, 1-faith_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, 1-faith_low_no_noise(:,1), 1-faith_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, 1-faith_mid_no_noise(:,1), 1-faith_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, 1-faith_high_no_noise(:,1), 1-faith_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Simultaneous presentation, noise SD = 0', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Proportion correct', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_faith_no_noise, 'no-noise_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for mean inhibition in network
    fig_inhibition_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, -inhibition_sum_low_no_noise(:,1), x, -inhibition_sum_mid_no_noise(:,1), '--', x, -inhibition_sum_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, -inhibition_sum_low_no_noise(:,1), -inhibition_sum_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, -inhibition_sum_mid_no_noise(:,1), -inhibition_sum_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, -inhibition_sum_high_no_noise(:,1), -inhibition_sum_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Simultaneous presentation, noise SD = 0', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean inhibition', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_inhibition_no_noise, 'no-noise_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with network where only nearest neighbors interfere with each
    % other
    % simultaneous presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if includeNearestNeighborNetwork
        
        if recalculateSimulations
            [mean_act_high_nn, faith_high_nn, inhibition_sum_high_nn] = knops_multiple_activation_functions(false, true, 0.15, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
            [mean_act_mid_nn, faith_mid_nn, inhibition_sum_mid_nn] = knops_multiple_activation_functions(false, true, 0.1, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
            [mean_act_low_nn, faith_low_nn, inhibition_sum_low_nn] = knops_multiple_activation_functions(false, true, 0.01, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        end;
        
        x = 1:length(mean_act_high_nn);
        
        % Figure for mean activation
        fig_ma_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, mean_act_low_nn(:,1), x, mean_act_mid_nn(:,1), '--', x, mean_act_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, mean_act_low_nn(:,1), mean_act_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, mean_act_mid_nn(:,1), mean_act_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, mean_act_high_nn(:,1), mean_act_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Mean activation', 'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_ma_nn, 'nn_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
        
        % Figure for Faithfullness
        fig_faith_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, 1-faith_low_nn(:,1), x, 1-faith_mid_nn(:,1), '--', x, 1-faith_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, 1-faith_low_nn(:,1), 1-faith_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, 1-faith_mid_nn(:,1), 1-faith_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, 1-faith_high_nn(:,1), 1-faith_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Proportion correct', 'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_faith_nn, 'nn_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
        
        % Figure for mean inhibition in network
        fig_inhibition_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, -inhibition_sum_low_nn(:,1), x, -inhibition_sum_mid_nn(:,1), '--', x, -inhibition_sum_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, -inhibition_sum_low_nn(:,1), inhibition_sum_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, -inhibition_sum_mid_nn(:,1), inhibition_sum_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, -inhibition_sum_high_nn(:,1), inhibition_sum_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Mean inhibition',  'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_inhibition_nn, 'nn_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    end; % includeNearestNeighborNetwork
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% SIMULATIONS WITH SEQUENTIAL PRESENTATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with fully connected network, sequential presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if recalculateSimulations
        [mean_act_seq_high, faith_seq_high, inhibition_seq_sum_high] = knops_multiple_activation_functions(true, true, 0.15, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq_mid, faith_seq_mid, inhibition_seq_sum_mid] = knops_multiple_activation_functions(true, true, 0.1, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq_low, faith_seq_low, inhibition_seq_sum_low] = knops_multiple_activation_functions(true, true, 0.01, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
    end;
    
    x = 1:length(mean_act_seq_high);
    
    % Figure for mean activation
    fig_ma_seq = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, mean_act_seq_low(:,1), x, mean_act_seq_mid(:,1), '--', x, mean_act_seq_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, mean_act_seq_low(:,1), mean_act_seq_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, mean_act_seq_mid(:,1), mean_act_seq_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, mean_act_seq_high(:,1), mean_act_seq_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation, noise SD = .03', 'FontSize', 20);
    end;
    xlabel('Set size', 'FontSize', 16);
    ylabel('Mean activation', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_ma_seq, 'seq_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for faith_seqfullness
    fig_faith_seq = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, 1-faith_seq_low(:,1), x, 1-faith_seq_mid(:,1), '--', x, 1-faith_seq_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, 1-faith_seq_low(:,1), 1-faith_seq_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, 1-faith_seq_mid(:,1), 1-faith_seq_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, 1-faith_seq_high(:,1), 1-faith_seq_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    if printTitle
        title('Sequential presentation, noise SD = .03', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Proportion correct', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_faith_seq, 'seq_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for mean inhibition_seq in network
    fig_inhibition_seq = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, -inhibition_seq_sum_low(:,1), x, -inhibition_seq_sum_mid(:,1), '--', x, -inhibition_seq_sum_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, -inhibition_seq_sum_low(:,1), -inhibition_seq_sum_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, -inhibition_seq_sum_mid(:,1), -inhibition_seq_sum_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, -inhibition_seq_sum_high(:,1), -inhibition_seq_sum_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    if printTitle
        title('Sequential presentation, noise SD = .03', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean inhibition', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_inhibition_seq, 'seq_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with fully connected network but no noise, sequential presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if recalculateSimulations
        [mean_act_seq_high_no_noise, faith_seq_high_no_noise, inhibition_seq_sum_high_no_noise] = knops_multiple_activation_functions(true, true, 0.15, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq_mid_no_noise, faith_seq_mid_no_noise, inhibition_seq_sum_mid_no_noise] = knops_multiple_activation_functions(true, true, 0.1, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq_low_no_noise, faith_seq_low_no_noise, inhibition_seq_sum_low_no_noise] = knops_multiple_activation_functions(true, true, 0.01, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
    end;
    
    x = 1:length(mean_act_seq_high_no_noise);
    
    % Figure for mean activation
    fig_ma_seq_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, mean_act_seq_low_no_noise(:,1), x, mean_act_seq_mid_no_noise(:,1), '--', x, mean_act_seq_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, mean_act_seq_low_no_noise(:,1), mean_act_seq_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, mean_act_seq_mid_no_noise(:,1), mean_act_seq_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, mean_act_seq_high_no_noise(:,1), mean_act_seq_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation, noise SD = 0', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean activation', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_ma_seq_no_noise, 'seq_no-noise_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for faith_seqfullness
    fig_faith_seq_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, 1-faith_seq_low_no_noise(:,1), x, 1-faith_seq_mid_no_noise(:,1), '--', x, 1-faith_seq_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, 1-faith_seq_low_no_noise(:,1), 1-faith_seq_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, 1-faith_seq_mid_no_noise(:,1), 1-faith_seq_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, 1-faith_seq_high_no_noise(:,1), 1-faith_seq_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation, noise SD = 0', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Proportion correct', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_faith_seq_no_noise, 'seq_no-noise_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for mean inhibition_seq in network
    fig_inhibition_seq_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, -inhibition_seq_sum_low_no_noise(:,1), x, -inhibition_seq_sum_mid_no_noise(:,1), '--', x, -inhibition_seq_sum_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, -inhibition_seq_sum_low_no_noise(:,1), -inhibition_seq_sum_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, -inhibition_seq_sum_mid_no_noise(:,1), -inhibition_seq_sum_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, -inhibition_seq_sum_high_no_noise(:,1), -inhibition_seq_sum_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation, noise SD = 0', 'FontSize', 20);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean inhibition', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_inhibition_seq_no_noise, 'seq_no-noise_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with network where only nearest neighbors interfere with each
    % other
    % sequential presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if includeNearestNeighborNetwork
        
        if recalculateSimulations
            [mean_act_seq_high_nn, faith_seq_high_nn, inhibition_seq_sum_high_nn] = knops_multiple_activation_functions(true, true, 0.15, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
            [mean_act_seq_mid_nn, faith_seq_mid_nn, inhibition_seq_sum_mid_nn] = knops_multiple_activation_functions(true, true, 0.1, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
            [mean_act_seq_low_nn, faith_seq_low_nn, inhibition_seq_sum_low_nn] = knops_multiple_activation_functions(true, true, 0.01, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        end;
        
        x = 1:length(mean_act_seq_high_nn);
        
        % Figure for mean activation
        fig_ma_seq_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, mean_act_seq_low_nn(:,1), x, mean_act_seq_mid_nn(:,1), '--', x, mean_act_seq_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, mean_act_seq_low_nn(:,1), mean_act_seq_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, mean_act_seq_mid_nn(:,1), mean_act_seq_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, mean_act_seq_high_nn(:,1), mean_act_seq_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Mean activation', 'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_ma_seq_nn, 'seq_nn_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
        
        % Figure for faith_seqfullness
        fig_faith_seq_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, 1-faith_seq_low_nn(:,1), x, 1-faith_seq_mid_nn(:,1), '--', x, 1-faith_seq_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, 1-faith_seq_low_nn(:,1), 1-faith_seq_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, 1-faith_seq_mid_nn(:,1), 1-faith_seq_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, 1-faith_seq_high_nn(:,1), 1-faith_seq_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Proportion correct', 'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_faith_seq_nn, 'seq_nn_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
        
        % Figure for mean inhibition_seq in network
        fig_inhibition_seq_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, -inhibition_seq_sum_low_nn(:,1), x, -inhibition_seq_sum_mid_nn(:,1), '--', x, -inhibition_seq_sum_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, -inhibition_seq_sum_low_nn(:,1), inhibition_seq_sum_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, -inhibition_seq_sum_mid_nn(:,1), inhibition_seq_sum_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, -inhibition_seq_sum_high_nn(:,1), inhibition_seq_sum_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Mean inhibition',  'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_inhibition_seq_nn, 'seq_nn_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    end;
    
    
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
        [mean_act_seq2_high, faith_seq2_high, inhibition_seq2_sum_high] = knops_multiple_activation_functions(true, false, 0.15, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq2_mid, faith_seq2_mid, inhibition_seq2_sum_mid] = knops_multiple_activation_functions(true, false, 0.1, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq2_low, faith_seq2_low, inhibition_seq2_sum_low] = knops_multiple_activation_functions(true, false, 0.01, false, .03, .03, 50, sqrt(2), actFncName, actFncParam);
    end;
    
    x = 1:length(mean_act_seq2_high);
    
    % Figure for mean activation
    fig_ma_seq2 = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, mean_act_seq2_low(:,1), x, mean_act_seq2_mid(:,1), '--', x, mean_act_seq2_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, mean_act_seq2_low(:,1), mean_act_seq2_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, mean_act_seq2_mid(:,1), mean_act_seq2_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, mean_act_seq2_high(:,1), mean_act_seq2_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation (continuous), noise SD = .03', 'FontSize', 18);
    end;
    xlabel('Set size', 'FontSize', 16);
    ylabel('Mean activation', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_ma_seq2, 'seq2_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for faith_seq2fullness
    fig_faith_seq2 = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, 1-faith_seq2_low(:,1), x, 1-faith_seq2_mid(:,1), '--', x, 1-faith_seq2_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, 1-faith_seq2_low(:,1), 1-faith_seq2_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, 1-faith_seq2_mid(:,1), 1-faith_seq2_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, 1-faith_seq2_high(:,1), 1-faith_seq2_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    if printTitle
        title('Sequential presentation (continuous), noise SD = .03', 'FontSize', 18);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Proportion correct', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_faith_seq2, 'seq2_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for mean inhibition_seq2 in network
    fig_inhibition_seq2 = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, -inhibition_seq2_sum_low(:,1), x, -inhibition_seq2_sum_mid(:,1), '--', x, -inhibition_seq2_sum_high(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, -inhibition_seq2_sum_low(:,1), -inhibition_seq2_sum_low(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, -inhibition_seq2_sum_mid(:,1), -inhibition_seq2_sum_mid(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, -inhibition_seq2_sum_high(:,1), -inhibition_seq2_sum_high(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    if printTitle
        title('Sequential presentation (continuous), noise SD = .03', 'FontSize', 18);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean inhibition', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_inhibition_seq2, 'seq2_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with fully connected network but no noise, sequential presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if recalculateSimulations
        [mean_act_seq2_high_no_noise, faith_seq2_high_no_noise, inhibition_seq2_sum_high_no_noise] = knops_multiple_activation_functions(true, false, 0.15, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq2_mid_no_noise, faith_seq2_mid_no_noise, inhibition_seq2_sum_mid_no_noise] = knops_multiple_activation_functions(true, false, 0.1, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
        [mean_act_seq2_low_no_noise, faith_seq2_low_no_noise, inhibition_seq2_sum_low_no_noise] = knops_multiple_activation_functions(true, false, 0.01, false, 0, .03, 50, sqrt(2), actFncName, actFncParam);
    end;
    
    x = 1:length(mean_act_seq2_high_no_noise);
    
    % Figure for mean activation
    fig_ma_seq2_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, mean_act_seq2_low_no_noise(:,1), x, mean_act_seq2_mid_no_noise(:,1), '--', x, mean_act_seq2_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, mean_act_seq2_low_no_noise(:,1), mean_act_seq2_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, mean_act_seq2_mid_no_noise(:,1), mean_act_seq2_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, mean_act_seq2_high_no_noise(:,1), mean_act_seq2_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean activation', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_ma_seq2_no_noise, 'seq2_no-noise_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for faith_seq2fullness
    fig_faith_seq2_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, 1-faith_seq2_low_no_noise(:,1), x, 1-faith_seq2_mid_no_noise(:,1), '--', x, 1-faith_seq2_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, 1-faith_seq2_low_no_noise(:,1), 1-faith_seq2_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, 1-faith_seq2_mid_no_noise(:,1), 1-faith_seq2_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, 1-faith_seq2_high_no_noise(:,1), 1-faith_seq2_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Proportion correct', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_faith_seq2_no_noise, 'seq2_no-noise_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    % Figure for mean inhibition_seq2 in network
    fig_inhibition_seq2_no_noise = figure;
    set(gca,'FontSize',14)
    
    if omitErrorBars
        plot (x, -inhibition_seq2_sum_low_no_noise(:,1), x, -inhibition_seq2_sum_mid_no_noise(:,1), '--', x, -inhibition_seq2_sum_high_no_noise(:,1), ':', 'Linewidth', 2);
    else
        hold on;
        errorbar (x, -inhibition_seq2_sum_low_no_noise(:,1), -inhibition_seq2_sum_low_no_noise(:,2), 'r-', 'Linewidth', 2);
        errorbar (x, -inhibition_seq2_sum_mid_no_noise(:,1), -inhibition_seq2_sum_mid_no_noise(:,2), 'b--', 'Linewidth', 2);
        errorbar (x, -inhibition_seq2_sum_high_no_noise(:,1), -inhibition_seq2_sum_high_no_noise(:,2), 'g:',  'Linewidth', 2);
        hold off;
    end;
    
    if printTitle
        title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
    end;
    xlabel('Set size',  'FontSize', 16);
    ylabel('Mean inhibition', 'FontSize', 16);
    if printLegend
        legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
    end;
    add_annotation(actFncText, 'nw', 20);
    
    save_figure_or_wait(fig_inhibition_seq2_no_noise, 'seq2_no-noise_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Simulations with network where only nearest neighbors interfere with each
    % other
    % sequential presentation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if includeNearestNeighborNetwork
        
        if recalculateSimulations
            [mean_act_seq2_high_nn, faith_seq2_high_nn, inhibition_seq2_sum_high_nn] = knops_multiple_activation_functions(true, false, 0.15, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
            [mean_act_seq2_mid_nn, faith_seq2_mid_nn, inhibition_seq2_sum_mid_nn] = knops_multiple_activation_functions(true, false, 0.1, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
            [mean_act_seq2_low_nn, faith_seq2_low_nn, inhibition_seq2_sum_low_nn] = knops_multiple_activation_functions(true, false, 0.01, true, .03, .03, 50, sqrt(2), actFncName, actFncParam);
        end;
        
        x = 1:length(mean_act_seq2_high_nn);
        
        % Figure for mean activation
        fig_ma_seq2_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, mean_act_seq2_low_nn(:,1), x, mean_act_seq2_mid_nn(:,1), '--', x, mean_act_seq2_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, mean_act_seq2_low_nn(:,1), mean_act_seq2_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, mean_act_seq2_mid_nn(:,1), mean_act_seq2_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, mean_act_seq2_high_nn(:,1), mean_act_seq2_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Mean activation', 'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_ma_seq2_nn, 'seq2_nn_mean_act.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
        
        % Figure for faith_seq2fullness
        fig_faith_seq2_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, 1-faith_seq2_low_nn(:,1), x, 1-faith_seq2_mid_nn(:,1), '--', x, 1-faith_seq2_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, 1-faith_seq2_low_nn(:,1), 1-faith_seq2_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, 1-faith_seq2_mid_nn(:,1), 1-faith_seq2_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, 1-faith_seq2_high_nn(:,1), 1-faith_seq2_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Proportion correct', 'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_faith_seq2_nn, 'seq2_nn_faith.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
        
        % Figure for mean inhibition_seq2 in network
        fig_inhibition_seq2_nn = figure;
        set(gca,'FontSize',14)
        
        if omitErrorBars
            plot (x, -inhibition_seq2_sum_low_nn(:,1), x, -inhibition_seq2_sum_mid_nn(:,1), '--', x, -inhibition_seq2_sum_high_nn(:,1), ':', 'Linewidth', 2);
        else
            hold on;
            errorbar (x, -inhibition_seq2_sum_low_nn(:,1), inhibition_seq2_sum_low_nn(:,2), 'r-', 'Linewidth', 2);
            errorbar (x, -inhibition_seq2_sum_mid_nn(:,1), inhibition_seq2_sum_mid_nn(:,2), 'b--', 'Linewidth', 2);
            errorbar (x, -inhibition_seq2_sum_high_nn(:,1), inhibition_seq2_sum_high_nn(:,2), 'g:',  'Linewidth', 2);
            hold off;
        end;
        
        if printTitle
            title('Nearest neighbor inhibition', 'FontSize', 20);
        end;
        xlabel('Set size',  'FontSize', 16);
        ylabel('Mean inhibition',  'FontSize', 16);
        if printLegend
            legend('low (.01)', 'medium (.1)', 'high (.15)', 'Location','east')
        end;
        add_annotation(actFncText, 'nw', 20);
        
        save_figure_or_wait(fig_inhibition_seq2_nn, 'seq2_nn_inhibition.png', saveFigures, ['figures_multiple_activation_functions/act_' actFncName '_']);
    end;
    
    if recalculateSimulations
        save(['knops_multiple_activation_functions.act_' actFncName '.mat']);
    end;
    
end; % for act_fnc_ind = 1:length(all_act_fnc)))

exit;