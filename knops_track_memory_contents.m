function [mean_activation, faithfulness, activation_in_early_and_late_targets, inhibition_sum] = knops_track_memory_contents(sequentialPresentation, letNetworkSettleDuringSequentialPresentation, b_arg, useDist, snoise_arg,  activation_threshold_arg, total_time_steps_arg)
% [mean_activation, faithfulness, inhibition_sum] = knops(b, useDist, snoise,  activation_threshold)
% If presentation is sequential, this function tracks the compares the
% activation level for the last (S_max-1)/2 active input neurons to a (S_max-1)/2
% (randomly chosen) input neurons that were active earlier.
% 
% As a result, we start running the model with set size 2 * S_max
%
% (c) Ansgar Endress
%
% Present the inputs one by one, let the network settle, and then record
% the final output
% 
% Arguments: 
% sequentialPresentation
%                should inputs be presented sequentially? (boolean)
%                default: false
%
% letNetworkSettleDuringSequentialPresentation
%                wait for total_time_steps-5 steps before presenting next 
%                item during sequential presentation? (boolean)
%                default: true
%
% b              interference parameter (double)
%                default: .15
%
% useDist        should i assume that the network is fully connected, or that only 
%                nearest neighbors interfere (boolean)
%                default: false
%
% snoise         standard deviation of the noise (double)
%                default: .03
%
% activation_threshold
%                threshold beyond which a neuron is considered active (double)    
%                default: snoise
%
% total_time_steps
%                total number of times steps for the simulation (integer)
%                default: 50
%
% Return values:
% mean_activation, faithfulness, inhibition_sum    
%                Arrays of the mean activation, the hamming
%                distance between input and activation, and the
%                mean inhibition
%                Columns: mean, se (across simulations)
%                Rows: set-size
    
    % Global parameters    
    global nneurons; % total number of neurons
    global nx;       % number of neurons in x direction
    global ny;       % number of neurons in y direction
    
    global input_time_steps; % number of time steps during which input is presented
    global total_time_steps; % total number of time steps

    
    global l;        % decay parameter
    global a;        % self activation parameter
    global b;        % inhibition parameter
    global snoise;   % standard deviation of the noise distribution
    global activation_threshold;   % threshold for considering a neuron active when converting to binary vectors    
    
    global smax;     % kind of the memory capacity of the network, see paper
    
    nneurons = 70;
    nx = 10;
    ny = 7;
    
    input_time_steps = 5;
    %total_time_steps = 50;
    
    l = 1;
    a = 2.2;

    % Process input arguments        
    if nargin < 7
        total_time_steps = 50; 
    else 
        total_time_steps = total_time_steps_arg;
    end;
    
    if nargin < 5
        snoise = .03;
    else
        snoise = snoise_arg;
    end;
    
    if nargin < 6
        activation_threshold = snoise;
    else
        activation_threshold = activation_threshold_arg;
    end;
    
    if nargin < 4
        useDist = false;
    end;

    if nargin < 3
        b = .15;
    else
        b = b_arg;
    end;
    
    if nargin < 2
        letNetworkSettleDuringSequentialPresentation = true;
    end;
    
    if nargin < 1
        sequentialPresentation = false;
    end;
    
    % calculate S_max
    smax = 1 + ((a-l) / b);
    if 2*smax >70
        error (sprintf('With b = %4f, S_max = %d, and thus too large for %d neurons.', ...
            b, in32(round(smax)), int32(nneurons)));
    end;
    
    function [act] = get_activation(x)
        % [act] = get_activation(x)
        % Apply the activation function to the vector x
        
        %act = x ./ (1 + x);
        act = rdivide (x, 1 + x);
        act(x<=0) = 0;        
        
    end

    function [ipattern] = generate_input_pattern(set_size)
        % [ipattern] = generate_input_pattern(set_size)
        % Generate a random vector with set_size 1's and nneurons-set_size
        % zeros
        % Assumes that nneurons is a global variable.
        
        if set_size > nneurons
            error ('The set size is larger than the number of neurons.');
        end;
        
        ipattern = [ones(set_size,1); zeros(nneurons-set_size,1)];
        
        % Shuffle comes from Psychtoolbox
        ipattern = Shuffle(ipattern);
    end
    
    function [binary_pattern] = threshold_pattern(continuous_pattern, threshold)
        % [binary_pattern] = threshold_pattern(continuous_pattern, theshold)
        % Thresholds a continuous valued activation pattern to a binary one
        % continuous_pattern:   continuous pattern
        % threshold:            threshold (optional)
        %                       default: .5
        
        if nargin < 2
            threshold = activation_threshold;
        end;
        
        binary_pattern = zeros(size(continuous_pattern));
        binary_pattern(continuous_pattern>threshold) = 1;        
    end

    function [coords] = get_coords_from_ind(inds)
        % [coords] = get_coords_from_ind(inds)
        % Takes a vector of indices, and calculates the coordinates in an
        % nx by ny matrix. Coordinates are calculated row by row.
        % Assumes that nx and ny are global variables.
        
        % these formulas are only valid when the reminder is not 0
        % that is, not in the last column. 
        x = rem(inds, nx);
        y = 1 + floor (inds/nx);
        
        % for a reminder of 0, this is a special case:
        y(x==0) = inds(x==0) / nx;
        x(x==0) = nx;
                
        coords = [x' y'];
        
    end % get_coords_from_ind

    function [new_act, inhibition_sum] = update_activation (old_act, dist, useDist, input)
        % [new_act] = update_activation (old_act, dist, input)
        % update the activation according to Knops' formula. 
        % old_act: vector of current activations
        %
        % dist:    matrix of distances between coordinates
        %
        % useDist: calculate interference as a function of distance between
        %          neurons (optional)
        %          default: false
        % 
        % input:   input vector (optional). If the input arguments is 
        %          not given, no input will be presented to the network. 
        
        % Knops' function is
        % dxi/dt = - l * xi + a * F(xi) - b sum F(x) + I_i + N
        % The discrete version is
        % xi(t) = xi(t-1) - l * xi(t-1) - b sum F(Xj(t-1) + Ii + noise
    
        
        if nargin < 4
            useInput = false;
        else
            useInput = true;
        end;
        
        if nargin < 3
            useDist = false;
        end;
        
        old_output = get_activation (old_act);
        
        decay = -l * old_act;
        
        self_excitation = a * old_output;
        
        noise = normrnd (0, snoise, size (old_act));
        
        if useDist==true
            % for the filter used by Itti & Koch, loock here: 
            % http://ilab.usc.edu/publications/doc/Itti_Koch00vr.pdf
            
            % here, we assume that inhibition arises only between nearest
            % neighbors, and exclude self-inhibition
            b_matrix = zeros(size(dist));
            b_matrix((dist > 0) & (dist<=sqrt(2))) = b;
            
            % rescale matrix to account for neurons that don't interfere
            % anymore
            %b_matrix = prod(size(b_matrix)) / nnz(b_matrix) * b_matrix;
                                    
        else
            
            b_matrix = b * ones(size(dist));
            % exclude self-inhibition
            b_matrix(logical(eye(size(b_matrix)))) = 0;
            
        end;
        
        inhibition = -b_matrix * old_output;
            
        % We already removed self-inhibition above
        new_act = old_act + decay + self_excitation + inhibition + noise;
                
        inhibition_sum = mean (inhibition);
                               
        % Add input if there is any
        if useInput==true
            new_act = new_act + input;
        end;

        % get rid of negative activations
        new_act(new_act<0) = 0;
        
    end

    function [mean_target_activations] = calculate_activation_in_late_and_early_targets(smax, input_pattern, output_pattern)
        
        n_targets = (smax-1)/2;
        
        binary_output_pattern = threshold_pattern(output_pattern);
        
        active_inputs = find(input_pattern);
        
        last_inputs = active_inputs((end-int32(n_targets)+1):end);
        
        other_inputs = active_inputs(1:(end-int32(n_targets)));
        other_inputs = randsample(other_inputs, int32(n_targets));
        
        mean_last_activation = mean (binary_output_pattern(last_inputs));
        
        mean_other_activation = mean (binary_output_pattern(other_inputs));
        
        mean_target_activations = [mean_other_activation mean_last_activation ];
        
    end

    function [mean_activation, faithfulness, activation_in_early_and_late_targets, inhibition_sum] = run_simulation(set_size, dist, useDist, sequentialPresentation, letNetworkSettleDuringSequentialPresentation, nsim)
        % [mean_activation, faithfulness] = run_simulation(set_size, dist, nsim)
        % 
        % Run nsim simulations for set_size
        % set_size:         desired set_size
        % dist:             matrix of distances between indices
        % letNetworkSettleDuringSequentialPresentation:
        %                   wait for total_time_steps-5 steps before presenting next
        %                   item during sequential presentation? (boolean)
        %                   default: true
        %
        % nsim:             number of simulations to run (option). 
        %                   default: 100
        %
        % mean_activation:  mean and se of the mean activation across 
        %                   simulations
        % faithfullness:    mean and se of the faithfullness 
        %                   simulations
        
        if nargin < 6
            nsim = 100;
        end;
        
        if nargin < 5
            letNetworkSettleDuringSequentialPresentation = true;
        end;
        
        if nargin < 4
            sequentialPresentation = false;
        end;
        
        mean_activation_array = [];
        faithfulness_array = [];
        activation_in_early_and_late_targets_array = [];
        inhibition_sum_array = [];
                
        for sim=1:nsim
            
            ipattern = generate_input_pattern (set_size);            
            
            current_activation = normrnd (0, snoise, size (ipattern));
            
            if sequentialPresentation
                
                % for some reason, we need to transpose ipattern here
                for current_input_neuron = find(ipattern')
                
                    current_input_vector = zeros(size(ipattern));
                    current_input_vector(current_input_neuron) = 1;
                    
                    for tstep=1:input_time_steps
                        [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist, current_input_vector);
                    end;                    
                    
                    % let the network activation settle here if it is left
                    % to settle between presentations
                    if letNetworkSettleDuringSequentialPresentation
                        for tstep=(input_time_steps+1):total_time_steps
                            [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist);
                        end;
                    end;
                end;
                
                % let the network activation settle only after the last
                % presentation if the network hasn't been given the chance
                % to settle before
                if ~letNetworkSettleDuringSequentialPresentation
                    for tstep=(input_time_steps+1):total_time_steps
                        [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist);
                    end;
                end;
                
            else % simultaneous presentation
                
                for tstep=1:input_time_steps
                    [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist, ipattern);
                end;
                
                for tstep=(input_time_steps+1):total_time_steps
                    [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist);
                end;
            end;
            
            mean_activation_array = [mean_activation_array mean(current_activation)];
            
            faithfulness_array = [faithfulness_array pdist2(threshold_pattern(current_activation)', ipattern', 'hamming')];
            % use cosine measure instead of hamming 
            %faithfulness_array = [faithfulness_array pdist2(current_activation, ipattern, 'cosine')];
            
            activation_in_early_and_late_targets_array = [activation_in_early_and_late_targets_array; ...
                calculate_activation_in_late_and_early_targets(smax, ipattern, current_activation)];
            
            inhibition_sum_array = [inhibition_sum_array mean(current_inhibition_sum)];
        end;
        
        mean_activation = [mean(mean_activation_array) std(mean_activation_array)/sqrt(nsim)];
        
        faithfulness = [mean(faithfulness_array) std(faithfulness_array)/sqrt(nsim)];
        
        activation_in_early_and_late_targets = [mean(activation_in_early_and_late_targets_array(:,1)) std(activation_in_early_and_late_targets_array(:,1)) ...
            mean(activation_in_early_and_late_targets_array(:,2)) std(activation_in_early_and_late_targets_array(:,2))];
                
        inhibition_sum = [mean(inhibition_sum_array) std(inhibition_sum_array)/sqrt(nsim)];
    end

if exist('Shuffle') ~= 2
    error('We need the Shuffle function. It is included in PsychToolBox.');
end;

coords = get_coords_from_ind(1:nneurons);

dist = pdist2 (coords, coords);


mean_activation = [];
faithfulness = [];
activation_in_early_and_late_targets = [];
inhibition_sum = [];
for ss=int32(ceil(2*smax)):70
    
    fprintf ('Running simulation with interference constant %0.4f and set size %d\n', b, ss);
    
    [ma, ff, act_el_targets, inhib] = run_simulation(ss, dist, useDist, sequentialPresentation, letNetworkSettleDuringSequentialPresentation);   
    
    mean_activation = [mean_activation; ma];
    faithfulness = [faithfulness; ff];
    activation_in_early_and_late_targets = [activation_in_early_and_late_targets; act_el_targets];
    inhibition_sum = [inhibition_sum; inhib];
end;

end



