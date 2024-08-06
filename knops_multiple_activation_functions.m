function [mean_activation, faithfulness, inhibition_sum, dprime, bbeta] = knops_multiple_activation_functions_c(sequentialPresentation, letNetworkSettleDuringSequentialPresentation, b_arg, useDist, snoise_arg,  activation_threshold_arg, total_time_steps_arg, max_inhibition_distance_arg, activation_fnc_arg, activation_fnc_param_arg)
% [mean_activation, faithfulness, inhibition_sum] = knops_multiple_activation_functions(sequentialPresentation, letNetworkSettleDuringSequentialPresentation, b, useDist, snoise,  activation_threshold, total_time_steps, max_inhibition_distance, activation_fnc, activation_fnc_param)
%
%
% (c) Ansgar Endress
%
% Present the inputs one by one, let the network settle, and then record
% the final output
%
% *** Arguments ***
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
% *** Return values ***
% mean_activation, faithfulness, inhibition_sum
%                Arrays of the mean activation, the hamming
%                distance between input and activation, and the
%                mean inhibition
%                Columns: mean, se (across simulations)
%                Rows: set-size
%    
% Changes 12/17/2019    
% * Added dprime, bbeta outputs   
% * Added get_sdt_analysis    
% * 

    
% Global parameters
global NNEURONS; % total number of neurons
global NX;       % number of neurons in x direction
global NY;       % number of neurons in y direction

global INPUT_TIME_STEPS; % number of time steps during which input is presented
global TOTAL_TIME_STEPS; % total number of time steps

global MAX_SET_SIZE;     % maximal set size to be simulated

global MAX_INHIBITION_DISTANCE; % radius of the circle in which inhibition takes place

global L;        % decay parameter
global A;        % self activation parameter
global B;        % inhibition parameter
global SNOISE;   % standard deviation of the noise distribution
global ACTIVATION_THRESHOLD;   % threshold for considering a neuron active when converting to binary vectors
global INPUT_ACTIVATION;       % value given to input

NNEURONS = 70;
NX = 10;
NY = 7;

INPUT_TIME_STEPS = 5;

MAX_SET_SIZE = 70;

L = 1;
A = 2.2;
INPUT_ACTIVATION = 1;

% Process input arguments
if nargin < 10
    ACTIVATION_FNC_PARAM = nan;
else
    ACTIVATION_FNC_PARAM = activation_fnc_param_arg;
end;

if nargin < 9
    ACTIVATION_FNC_NAME = 'knops';
    ACTIVATION_FNC_HANDLE = act_fnc_name_to_handle(ACTIVATION_FNC_NAME);
else
    ACTIVATION_FNC_NAME = activation_fnc_arg;
    ACTIVATION_FNC_HANDLE = act_fnc_name_to_handle(ACTIVATION_FNC_NAME);
end;

if nargin < 8
    MAX_INHIBITION_DISTANCE = sqrt(2);
else
    MAX_INHIBITION_DISTANCE = max_inhibition_distance_arg;
end;

if nargin < 7
    TOTAL_TIME_STEPS = 50;
else
    TOTAL_TIME_STEPS = total_time_steps_arg;
end;

if nargin < 5
    SNOISE = .03;
else
    SNOISE = snoise_arg;
end;

if nargin < 6
    ACTIVATION_THRESHOLD = SNOISE;
else
    ACTIVATION_THRESHOLD = activation_threshold_arg;
end;

if nargin < 4
    useDist = false;
end;

if nargin < 3
    B = .15;
else
    B = b_arg;
end;

if nargin < 2
    letNetworkSettleDuringSequentialPresentation = true;
end;

if nargin < 1
    sequentialPresentation = false;
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
        % Generate a random vector with set_size 1's and NNEURONS-set_size
        % zeros
        % Assumes that NNEURONS is a global variable.
        
        if set_size > NNEURONS
            error ('The set size is larger than the number of neurons.');
        end;
        
        ipattern = [INPUT_ACTIVATION * ones(set_size,1); zeros(NNEURONS-set_size,1)];
        
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
            threshold = ACTIVATION_THRESHOLD;
        end;
        
        binary_pattern = zeros(size(continuous_pattern));
        binary_pattern(continuous_pattern>threshold) = 1;
    end

    function [coords] = get_coords_from_ind(inds)
        % [coords] = get_coords_from_ind(inds)
        % Takes a vector of indices, and calculates the coordinates in an
        % NX by NY matrix. Coordinates are calculated row by row.
        % Assumes that NX and NY are global variables.
        
        % these formulas are only valid when the reminder is not 0
        % that is, not in the last column.
        x = rem(inds, NX);
        y = 1 + floor (inds/NX);
        
        % for a reminder of 0, this is a special case:
        y(x==0) = inds(x==0) / NX;
        x(x==0) = NX;
        
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
        
        decay = -L * old_act;
        
        self_excitation = A * old_output;
        
        noise = normrnd (0, SNOISE, size (old_act));
        
        if useDist==true
            % for the filter used by Itti & Koch, loock here:
            % http://ilab.usc.edu/publications/doc/Itti_Koch00vr.pdf
            
            % here, we assume that inhibition arises only between nearest
            % neighbors, and exclude self-inhibition
            b_matrix = zeros(size(dist));
            b_matrix((dist > 0) & (dist<=MAX_INHIBITION_DISTANCE)) = B;
            
            % rescale matrix to account for neurons that don't interfere
            % anymore
            %b_matrix = prod(size(b_matrix)) / nnz(b_matrix) * b_matrix;
            
        else
            
            b_matrix = B * ones(size(dist));
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

    function [mean_activation, faithfulness, inhibition_sum, dprime, bbeta] = run_simulation(set_size, dist, useDist, sequentialPresentation, letNetworkSettleDuringSequentialPresentation, nsim)
    % [mean_activation, faithfulness, inhibition_sum, dprime,
    % bbeta] = run_simulation(set_size, dist, useDist,
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
        
        mean_activation_array = zeros(1,nsim);
        faithfulness_array = zeros(1,nsim);
        dprime_array = zeros(1,nsim);
        bbeta_array = zeros(1,nsim);
        inhibition_sum_array = zeros(1,nsim);
        
        for sim=1:nsim
            
            ipattern = generate_input_pattern (set_size);
            
            current_activation = normrnd (0, SNOISE, size (ipattern));
            
            if sequentialPresentation
                
                % for some reason, we need to transpose ipattern here
                for current_input_neuron = find(ipattern')
                    
                    current_input_vector = zeros(size(ipattern));
                    %                    current_input_vector(current_input_neuron) = 1;
                    current_input_vector(current_input_neuron) = INPUT_ACTIVATION;
                    
                    for tstep=1:INPUT_TIME_STEPS
                        [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist, current_input_vector);
                    end;
                    
                    % let the network activation settle here if it is left
                    % to settle between presentations
                    if letNetworkSettleDuringSequentialPresentation
                        for tstep=(INPUT_TIME_STEPS+1):TOTAL_TIME_STEPS
                            [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist);
                        end;
                    end;
                end;
                
                % let the network activation settle only after the last
                % presentation if the network hasn't been given the chance
                % to settle before
                if ~letNetworkSettleDuringSequentialPresentation
                    for tstep=(INPUT_TIME_STEPS+1):TOTAL_TIME_STEPS
                        [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist);
                    end;
                end;
                
            else % simultaneous presentation
                
                for tstep=1:INPUT_TIME_STEPS
                    [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist, ipattern);
                end;
                
                for tstep=(INPUT_TIME_STEPS+1):TOTAL_TIME_STEPS
                    [current_activation, current_inhibition_sum] = update_activation (current_activation, dist, useDist);
                end;
            end;
            
            mean_activation_array(1,sim) = mean(current_activation);
            
            faithfulness_array(1,sim) = pdist2(threshold_pattern(current_activation)', threshold_pattern(ipattern)', 'hamming');
            % use cosine measure instead of hamming
            %faithfulness_array(1,sim) = pdist2(current_activation, ipattern, 'cosine');

            [current_dprime, current_beta] = get_sdt_analysis(threshold_pattern(current_activation)', threshold_pattern(ipattern)');
            dprime_array(1,sim) = current_dprime;
            bbeta_array(1,sim) = current_beta;
                        
            inhibition_sum_array(1,sim) = mean(current_inhibition_sum);
        end;
        
        mean_activation = [mean(mean_activation_array) std(mean_activation_array)/sqrt(nsim)];
        faithfulness = [mean(faithfulness_array) std(faithfulness_array)/sqrt(nsim)];
        dprime = [mean(dprime_array), std(dprime_array)/sqrt(nsim)];
        bbeta = [mean(bbeta_array) std(bbeta_array)/sqrt(nsim)];        
        inhibition_sum = [mean(inhibition_sum_array) std(inhibition_sum_array)/sqrt(nsim)];
    end

if ~exist('Shuffle', 'file')
    error('We need the Shuffle function. It is included in PsychToolBox.');
end;

coords = get_coords_from_ind(1:NNEURONS);

dist = pdist2 (coords, coords);


mean_activation = zeros(MAX_SET_SIZE,2);
faithfulness = zeros(MAX_SET_SIZE,2);
dprime = zeros(MAX_SET_SIZE,2);
bbeta = zeros(MAX_SET_SIZE,2);
inhibition_sum = zeros(MAX_SET_SIZE,2);
for ss=1:MAX_SET_SIZE
    
    fprintf ('Running simulation with activation function %s, interference constant %0.4f and set size %d\n', ACTIVATION_FNC_NAME,B, ss);
    
    [ma, ff, inhib, dprm, bbta] = run_simulation(ss, dist, useDist, sequentialPresentation, letNetworkSettleDuringSequentialPresentation);
    
    mean_activation(ss,:) = ma;
    faithfulness(ss,:) = ff;
    dprime(ss,:) = dprm;
    bbeta(ss,:) = bbta;
    inhibition_sum(ss,:) = inhib;
end;

end



