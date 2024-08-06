% Launch and analyze simulations where we vary the maximal distance
% at which neurons interact
% We don't include any simulations with simultaneous presentation.

%clear all;
recalculate_simulations = true;
save_results = true;

if ~recalculate_simulations  
    load('knops_max_dist_large_network.mat');
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculate_simulations
    % We use only high inhibition simulations, since this is where we find
    % limited capacities
    mean_act_seq_high_large_network_max_dist = zeros(70,19);
    faith_seq_high_large_network_max_dist = zeros(70,19);
    
    
    % since we place the 40 neurons on a 20 x 20 matrix, the maximal possible
    % distance is 19
    parfor max_straight_dist=1:19
        
        fprintf ('Running simulation with a maximal distance of %d\n', max_straight_dist);
        
        % max_straight_dist is the horizontal/vertical distance
        % it needs to be multiplied with sqrt (2) for the diagnol elements
        
        max_dist = sqrt(2) * max_straight_dist;
                
        [mean_act_seq_high_large_network_max_dist(:,max_straight_dist), faith_seq_high_large_network_max_dist(:,max_straight_dist) ] = ...
            knops_large_network_wrapper(true, true, 0.15, true, .03, .03, 50, max_dist);        
        
    end;
end;

x = 1:size(mean_act_seq_high_large_network_max_dist,2);
y = 1:size(mean_act_seq_high_large_network_max_dist,1);


% Figure for mean activation
fig_ma_seq_large_network_max_dist = figure;
set(gca,'FontSize',14)

surfc (x, y, mean_act_seq_high_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation, noise SD = .03', 'FontSize', 20);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Mean activation', 'FontSize', 16);

saveas(fig_ma_seq_large_network_max_dist, 'large_network_max_dist_seq_mean_act.png');

% Figure for faithfullness
fig_faith_seq = figure;
set(gca,'FontSize',14)

surfc (x, y, 1-faith_seq_high_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation, noise SD = .03', 'FontSize', 20);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Proportion correct', 'FontSize', 16);

saveas(fig_faith_seq_large_network_max_dist, 'large_network_max_dist_seq_faith.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculate_simulations
    % We use only high inhibition simulations, since this is where we find
    % limited capacities
    mean_act_seq_high_no_noise_large_network_max_dist = zeros(70,19);
    faith_seq_high_no_noise_large_network_max_dist = zeros(70,19);
    
    % since we place the 40 neurons on a 20 x 20 matrix, the maximal possible
    % distance is 19
    parfor max_straight_dist=1:19
        
        fprintf ('Running simulation with a maximal distance of %d\n', max_straight_dist);
        
        % max_straight_dist is the horizontal/vertical distance
        % it needs to be multiplied with sqrt (2) for the diagnol elements
        
        max_dist = sqrt(2) * max_straight_dist;
        
        [mean_act_seq_high_no_noise_large_network_max_dist(:,max_straight_dist), faith_seq_high_no_noise_large_network_max_dist(:,max_straight_dist)] = ...
            knops_large_network_wrapper(true, true, 0.15, true, 0, .03, 50, max_dist);
        
    end;
end;

x = 1:size(mean_act_seq_high_no_noise_large_network_max_dist,2);
y = 1:size(mean_act_seq_high_no_noise_large_network_max_dist,1);


% Figure for mean activation
fig_ma_seq_no_noise_large_network_max_dist = figure;
set(gca,'FontSize',14)


surfc (x, y, mean_act_seq_high_no_noise_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation, noise SD = 0', 'FontSize', 20);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Mean activation', 'FontSize', 16);

saveas(fig_ma_seq_no_noise_large_network_max_dist, 'large_network_max_dist_seq_no-noise_mean_act.png');

% Figure for faith_seqfullness
fig_faith_seq_no_noise_large_network_max_dist = figure;
set(gca,'FontSize',14)

set(gca,'FontSize',14)

surfc (x, y, 1-faith_seq_high_no_noise_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation, noise SD = 0', 'FontSize', 20);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Proportion correct', 'FontSize', 16);

saveas(fig_faith_seq_no_noise_large_network_max_dist, 'large_network_max_dist_seq_no-noise_faith.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS WITH SEQUENTIAL PRESENTATION 
%% NO WAITING PERIOD BETWEEN PRESENTATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculate_simulations
    % We use only high inhibition simulations, since this is where we find
    % limited capacities
    mean_act_seq2_high_large_network_max_dist = zeros(70,19);
    faith_seq2_high_large_network_max_dist = zeros(70,19);
    
    
    % since we place the 40 neurons on a 20 x 20 matrix, the maximal possible
    % distance is 19
    parfor max_straight_dist=1:19
        
        fprintf ('Running simulation with a maximal distance of %d\n', max_straight_dist);
        
        % max_straight_dist is the horizontal/vertical distance
        % it needs to be multiplied with sqrt (2) for the diagnol elements
        
        max_dist = sqrt(2) * max_straight_dist;
        
        [mean_act_seq2_high_large_network_max_dist(:,max_straight_dist), faith_seq2_high_large_network_max_dist(:,max_straight_dist)] = ...
            knops_large_network_wrapper(true, false, 0.15, true, .03, .03, 50, max_dist);
        
    end;
end;

x = 1:size(mean_act_seq2_high_large_network_max_dist,2);
y = 1:size(mean_act_seq2_high_large_network_max_dist,1);


% Figure for mean activation
fig_ma_seq2_large_network_max_dist = figure;
set(gca,'FontSize',14)

surfc (x, y, mean_act_seq2_high_large_network_max_dist);
% azimuth and elevation
view (-80, 20);
colorbar();

title('Sequential presentation (continuous), noise SD = .03', 'FontSize', 18);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Mean activation', 'FontSize', 16);

saveas(fig_ma_seq2_large_network_max_dist, 'large_network_max_dist_seq2_mean_act.png');

% Figure for faithfullness
fig_faith_seq2_large_network_max_dist = figure;
set(gca,'FontSize',14)

surfc (x, y, 1-faith_seq2_high_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation (continuous), noise SD = .03', 'FontSize', 18);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Proportion correct', 'FontSize', 16);

saveas(fig_faith_seq2_large_network_max_dist, 'large_network_max_dist_seq2_faith.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations with fully connected network but no noise, sequential presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculate_simulations
    % We use only high inhibition simulations, since this is where we find
    % limited capacities
    mean_act_seq2_high_no_noise_large_network_max_dist = zeros(70,19);
    faith_seq2_high_no_noise_large_network_max_dist = zeros(70,19);
    
    % since we place the 40 neurons on a 20 x 20 matrix, the maximal possible
    % distance is 19
    parfor max_straight_dist=1:19
        
        fprintf ('Running simulation with a maximal distance of %d\n', max_straight_dist);
        
        % max_straight_dist is the horizontal/vertical distance
        % it needs to be multiplied with sqrt (2) for the diagnol elements
        
        max_dist = sqrt(2) * max_straight_dist;
        
        [mean_act_seq2_high_no_noise_large_network_max_dist(:,max_straight_dist), faith_seq2_high_no_noise_large_network_max_dist(:,max_straight_dist)] = ...
            knops_large_network_wrapper(true, false, 0.15, true, 0, .03, 50, max_dist);
        
    end;
end;

x = 1:size(mean_act_seq2_high_no_noise_large_network_max_dist,2);
y = 1:size(mean_act_seq2_high_no_noise_large_network_max_dist,1);


% Figure for mean activation
fig_ma_seq2_no_noise_large_network_max_dist = figure;
set(gca,'FontSize',14)

surfc (x, y, mean_act_seq2_high_no_noise_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Mean activation', 'FontSize', 16);


saveas(fig_ma_seq2_no_noise_large_network_max_dist, 'large_network_max_dist_seq2_no-noise_mean_act.png');

% Figure for faithfullness
fig_faith_seq2_no_noise = figure;
set(gca,'FontSize',14)

surfc (x, y, 1-faith_seq2_high_no_noise_large_network_max_dist);
view ([30, -20, 10]);
colorbar();

title('Sequential presentation (continuous), noise SD = 0', 'FontSize', 18);
xlabel('Maximal distance',  'FontSize', 16);
ylabel('Set size',  'FontSize', 16);
zlabel('Proportion correct', 'FontSize', 16);

saveas(fig_faith_seq2_no_noise, 'large_network_max_dist_seq2_no-noise_faith.png');


% save all the results
if recalculate_simulations
    if save_results
        save('knops_max_dist_large_network.mat');
    end;
end;

