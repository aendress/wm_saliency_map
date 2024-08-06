function [mean_activation_mean_only, faithfulness_mean_only] = knops_large_network_wrapper(sequentialPresentation, letNetworkSettleDuringSequentialPresentation, b_arg, useDist, snoise_arg,  activation_threshold_arg, total_time_steps_arg, max_inhibition_distance_arg)
% This function calls knops_large_network, but returns the result so that
% they can be used in the parfor loops in knops_max_distance_large_network_launcher

[mean_act_tmp, faith_tmp] = knops_large_network(sequentialPresentation, letNetworkSettleDuringSequentialPresentation, b_arg, useDist, snoise_arg,  activation_threshold_arg, total_time_steps_arg, max_inhibition_distance_arg);

mean_activation_mean_only = mean_act_tmp(:,1);
faithfulness_mean_only = faith_tmp(:,1);

end