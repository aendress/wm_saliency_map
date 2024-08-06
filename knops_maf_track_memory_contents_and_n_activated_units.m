function [mean_activation, faithfulness, activation_in_early_and_late_targets, inhibition_sum, n_active_neurons, mean_activation_in_active_neurons, binCounts, binCounts_by_setSize, dprime, bbeta] = knops_maf_track_memory_contents_and_n_activated_units(sequentialPresentation, letNetworkSettleDuringSequentialPresentation, b_arg, useDist, snoise_arg,  activation_threshold_arg, total_time_steps_arg, activation_fnc_arg, activation_fnc_param_arg)
% [mean_activation, faithfulness, inhibition_sum] = knops(b, useDist, snoise,  activation_threshold)
% If presentation is sequential, this function tracks the compares the
% activation level for the last S_max active input neurons to a S_max
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
% max_inhibition_distance
%                maximal distance (in a 2x2 matrix) within which interference can occur
%                used only if useDist is true
%                default: sqrt(2)
%
% activation_fnc
%                activation function
%                Supported functions:
%                    knops
%                    threshold
%                    linear
%                    sigmoid
%                    relu
%                    tanh
%                Default: knops
%
% activation_fnc_param
%                parameters for the activation function that support them
%                functions with parameters:
%                    threshold: threshold (default: ACTIVATION_THRESHOLD)
%                    linear: scaling (default: 1)
%
%
% Return values:
% mean_activation, faithfulness, activation_in_early_and_late_targets, inhibition_sum    
%                Arrays of the mean activation, the hamming
%                distance between input and activation, and the
%                mean inhibition
%                Columns: mean, se (across simulations)
%                Rows: set-size
% Other output    
% n_active_neurons, mean_activation_in_active_neurons, dprime, bbeta    
%    
% Changes 12/17/2019    
% * Added dprime, bbeta outputs   
% * Added get_sdt_analysis    
% * 


% To check the distribution of the network activation, we use the following
% data structures: 
% These are the data structures to hold the activation
% Dimensions for cell array holding data across set-sizes:
%    - Set size
%    - Number of simulations per set size
%    - Array holding all activations
% This is used in the main function
%
% act_by_setSize_sim = cell(nneurons, nsim, 1);
% Dimensions for cell array holding data for a given set-size:
%    - Number of simulations per set size
%    - Array holding all activations
% This is used where the similations are run
% act_by_sim = cell(nsim, 1);
% For each simulation at a given set size:
% act_by_sim(sim,1) = {current_activation};


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
if nargin < 9
    ACTIVATION_FNC_PARAM = nan;
else
    ACTIVATION_FNC_PARAM = activation_fnc_param_arg;
end;

if nargin < 8
    ACTIVATION_FNC_NAME = 'knops';
    ACTIVATION_FNC_HANDLE = act_fnc_name_to_handle(ACTIVATION_FNC_NAME);
else
    ACTIVATION_FNC_NAME = activation_fnc_arg;
    ACTIVATION_FNC_HANDLE = act_fnc_name_to_handle(ACTIVATION_FNC_NAME);
end;

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
    warning (sprintf('With b = %4f, S_max = %d, and thus too large for %d neurons.', ...
        b, int32(round(smax)), int32(nneurons)));
end;

    % Handles to various activation functions

    function [h] = get_knops_handle
        
        h = @knops_act_fun;
        
        function [act] = knops_act_fun(x)
            %act = x ./ (1 + x);
            act = rdivide (x, 1 + x);
            act(x<=0) = 0;
        end
    end

    function [h] = get_threshold_handle
        
        h = @threshold_act_fun;
        
        function [act] = threshold_act_fun(x, threshold)
            
            if nargin < 2
                threshold = ACTIVATION_THRESHOLD;
            end;
            
            act = zeros(size(x));
            act(x>threshold) = 1;
        end
    end

    function [h] = get_linear_handle
        
        h = @linear_act_fun;
        
        function [act] = linear_act_fun(x, scaling)
            if nargin < 2
                scaling = 1;
            end;
            
            act = scaling * x;
        end
    end

    function [h] = get_linear_with_offset_handle
        
        h = @linear_with_offset_act_fun;
        
        function [act] = linear_with_offset_act_fun(x, scaling, offset)
            if nargin < 3
                offset = .5;
            end;
            
            if nargin < 2
                scaling = 1;
            end;
            
            act = (scaling * x) + offset;
        end
    end

    
    function [h] = get_sigmoid_handle
        
        h = @sigmoid_act_fun;
        
        function [act] = sigmoid_act_fun(x)
            act = (1 ./ (1 + exp(-x))) - .5;
        end
        
    end

    function [h] = get_relu_handle
        % rectified linear unit
        
        h = @relu_act_fun;
        
        function [act] = relu_act_fun(x)
            
            act = max(0, x);
        end
        
    end

    function [h] = get_tanh_handle
        
        h = @tanh_act_fun;
        
        
        function [act] = tanh_act_fun(x)
            
            act = (exp(x) - exp(-x)) ./ (exp(x) + exp(-x));
            
        end
    end


    function [h] = act_fnc_name_to_handle(activation_fnc_name)
        % [h] = act_fnc_name_to_handle(activation_fnc_name)
        % Generates a handle for the function specified by its name
        
        if (nargin < 1)
            
            warning('act_fnc_name_to_handle: Unspecified activation function, using default');
            activation_handle = get_knops_handle;
            
        else
            
            switch lower(activation_fnc_name)
                case 'knops'
                    h = get_knops_handle;
                    
                case 'threshold'
                    h = get_threshold_handle;
                    
                case 'linear'
                    h = get_linear_handle;
                    
                case 'linear_offset'
                  h = get_linear_with_offset_handle;
                    
                case 'sigmoid'
                    h = get_sigmoid_handle;
                    
                case 'relu'
                    h = get_relu_handle;
                    
                case 'tanh'
                    h = get_tanh_handle;
                    
                otherwise
                    warning('act_fnc_name_to_handle: Unknown activation function, using default');
                    h = get_knops_handle;
            end;
        end;
        
    end

% End of Handles to various activation functions

    function [act] = get_activation(x, activation_handle, varargin)
        % [act] = get_activation(x, [activation_handle], [activation function parameter])
        % Apply the activation function identified by activation_handle
        % to the vector x. Note that activation_handle must be a
        % HANDLE, not a name of a function
        
        if ((nargin > 2) && ~isnan(varargin{1}))
            act = activation_handle(x, varargin{1});
        elseif (nargin > 1)
            act = activation_handle(x);
        elseif (nargin > 0)
            activation_handle = get_knops_handle;
            act = activation_handle(x);
        else
            error ('get_activation: at least one argument is required.');
        end;
        
    end

%     function [act] = get_activation_old(x)
%         % [act] = get_activation(x)
%         % Apply the activation function to the vector x
%
%         %act = x ./ (1 + x);
%         act = rdivide (x, 1 + x);
%         act(x<=0) = 0;
%
%     end


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

    function [dprime, bbeta] = get_sdt_analysis(thresholded_activation, ipattern)
    % [dprime, bbeta] = get_sdt_analysis(thresholded_activation, ipattern)

        %ipattern = [ones(set_size,1); zeros(nneurons-set_size,1)];
        %thresholded_activation = repmat ([1 0], 1, 5);

        h_count = sum (thresholded_activation(ipattern==1));
        fa_count = sum(  thresholded_activation(ipattern==0) == 1 );

        % loglinear correction recommended by Hautus and Lee, 2006, British Journal of Mathematical and Statistical Psychology
        h_rate = (h_count + .5) / (sum(ipattern==1) + 1);
        fa_rate = (fa_count + .5) / (sum(ipattern==0) + 1);

        h_z = norminv(h_rate);
        fa_z = norminv(fa_rate);


        dprime = h_z - fa_z;
        dprime(dprime<0) = 0;
        
        bbeta =  exp(-h_z*h_z/2 + fa_z*fa_z/2);

    end % get_sdt_analysis
    
    
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
        
        old_output = get_activation (old_act, ACTIVATION_FNC_HANDLE, ACTIVATION_FNC_PARAM);
        
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
        
        binary_output_pattern = threshold_pattern(output_pattern);
        
        active_inputs = find(input_pattern);
        
        last_inputs = active_inputs((end-int32(smax)+1):end);
        
        other_inputs = active_inputs(1:(end-int32(smax)));
        other_inputs = randsample(other_inputs, int32(smax));
        
        mean_last_activation = mean (binary_output_pattern(last_inputs));
        
        mean_other_activation = mean (binary_output_pattern(other_inputs));
        
        mean_target_activations = [mean_other_activation mean_last_activation ];
        
    end

    function [mean_activation, faithfulness, activation_in_early_and_late_targets, inhibition_sum, n_active_neurons, mean_activation_in_active_neurons, act_by_sim, dprime, bbeta] = run_simulation_track_number(set_size, dist, useDist, sequentialPresentation, letNetworkSettleDuringSequentialPresentation, nsim)
    % [mean_activation, faithfulness,
    % activation_in_early_and_late_targets, inhibition_sum,
    % n_active_neurons, mean_activation_in_active_neurons,
    % act_by_sim, dprime, bbeta] =
    % run_simulation_track_number(set_size, dist, useDist,
    % sequentialPresentation,
    % letNetworkSettleDuringSequentialPresentation, nsim)
    %    
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
        dprime_array = [];
        bbeta_array = [];
        activation_in_early_and_late_targets_array = [];
        inhibition_sum_array = [];
        n_active_neurons_array = [];
        mean_activation_in_active_neurons_array = [];
        % Dimensions for cell array holding data for a given set-size:
        %    - Number of simulations per set size
        %    - Array holding all activations
        act_by_sim = cell(nsim, 1);

        
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
            
            current_activation_thresholded = threshold_pattern(current_activation);
            
            faithfulness_array = [faithfulness_array pdist2(current_activation_thresholded', ipattern', 'hamming')];
            % use cosine measure instead of hamming
            %faithfulness_array = [faithfulness_array pdist2(current_activation, ipattern, 'cosine')];
            
            [current_dprime, current_beta] = get_sdt_analysis(current_activation_thresholded', ipattern);
            dprime_array = [dprime_array current_dprime];
            bbeta_array = [bbeta_array current_beta];
            
            if (2 * smax < 70)
                activation_in_early_and_late_targets_array = [activation_in_early_and_late_targets_array; ...
                    calculate_activation_in_late_and_early_targets(smax, ipattern, current_activation)];
            else
                warning(['smax too large (' num2str(int32(smax)) '). Returning std of activation across neurons']);
                activation_in_early_and_late_targets_array = [activation_in_early_and_late_targets_array; ...
                    std(current_activation) * ones(1,4)];
            end;
            
            inhibition_sum_array = [inhibition_sum_array mean(current_inhibition_sum)];
            
            n_active_neurons_array = [n_active_neurons_array sum(current_activation_thresholded)];
            
            mean_activation_in_active_neurons_array = [mean_activation_in_active_neurons_array mean(current_activation(current_activation_thresholded==1))];
            
            act_by_sim(sim,1) = {current_activation'};
            
        end;
        
        mean_activation = [mean(mean_activation_array) std(mean_activation_array)/sqrt(nsim)];
        
        faithfulness = [mean(faithfulness_array) std(faithfulness_array)/sqrt(nsim)];
        
        dprime = [mean(dprime_array), std(dprime_array)/sqrt(nsim)];
        bbeta = [mean(bbeta_array) std(bbeta_array)/sqrt(nsim)];
        
        activation_in_early_and_late_targets = [mean(activation_in_early_and_late_targets_array(:,1)) std(activation_in_early_and_late_targets_array(:,1)) ...
            mean(activation_in_early_and_late_targets_array(:,2)) std(activation_in_early_and_late_targets_array(:,2))];
        
        inhibition_sum = [mean(inhibition_sum_array) std(inhibition_sum_array)/sqrt(nsim)];
        
        n_active_neurons = [mean(n_active_neurons_array) std(n_active_neurons_array)/sqrt(nsim)];
        
        mean_activation_in_active_neurons = [mean(mean_activation_in_active_neurons_array) std(mean_activation_in_active_neurons_array)/sqrt(nsim)];
        
    end

if exist('Shuffle') ~= 2
    error('We need the Shuffle function. It is included in PsychToolBox.');
end;

coords = get_coords_from_ind(1:nneurons);

dist = pdist2 (coords, coords);


mean_activation = [];
faithfulness = [];
dprime = [];
bbeta = [];
activation_in_early_and_late_targets = [];
inhibition_sum = [];
n_active_neurons = [];
mean_activation_in_active_neurons = [];
% Dimensions for cell array holding data across set-sizes:
%    - Set size
%    - Number of simulations per set size
%    - Array holding all activations
act_by_setSize_sim = cell(nneurons, 100, 1);
binCounts_by_setSize = cell(nneurons, 1);
if 2*smax < 70
    n_min = int32(ceil(2*smax));
else
    n_min = 1;
end;

for ss=n_min:70
    %for ss=1:70
    
    fprintf ('Running simulation with interference constant %0.4f and set size %d\n', b, ss);
            
    [ma, ff, act_el_targets, inhib, n_active, ma_in_active, act_by_sim, dprm, bbta] = run_simulation_track_number(ss, dist, useDist, sequentialPresentation, letNetworkSettleDuringSequentialPresentation);
    
    mean_activation = [mean_activation; ma];
    faithfulness = [faithfulness; ff];
    dprime = [dprime; dprm];
    bbeta = [bbeta; bbta];    
    activation_in_early_and_late_targets = [activation_in_early_and_late_targets; act_el_targets];
    inhibition_sum = [inhibition_sum; inhib];
    n_active_neurons = [n_active_neurons; n_active];
    mean_activation_in_active_neurons = [mean_activation_in_active_neurons; ma_in_active];

    act_by_setSize_sim(ss,:,:) = act_by_sim;
    binCountsTmp = cellfun(@(x) count_data_in_bin(x, 20, 0, 2), act_by_sim,'UniformOutput',false);
        binCounts_by_setSize{ss} = colMeansTable(binCountsTmp);
end;

binCounts = colMeansTable(binCounts_by_setSize);
end



