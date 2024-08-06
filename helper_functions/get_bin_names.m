function [binNames] = get_bin_names(edges)
% function [binNames] = get_bin_names(edges)
% Create labels for the bins; assumes that the first and the last edge are
% +/-Inf

% Apparently, histc creates the following bins: 
% edge(1) <= x < edge(2)
% edge(2) <= x < edge(3)
% ...
% edge(end) == x
% 
% If +/- Inf is included among the edges, we thus have (where edge is
% the user specified edge array):
% 
% x < edge(1)
% edge(1) <= x < edge(2)
% edge(2) <= x < edge(3)
% ...
% edge(end-1) <= x < edge(end)
% edge(end) <= x
% Inf == x
% 

if isinf(-edges(1)) && isinf(edges(end))
    includeInf = true;
else
    includeInf = false;
    error ('Not yet implemented');
end;


edges = edges(2:end-1);

binNames = {['x_lt_' num2str(edges(1))]};
for i=1:(length(edges)-1)
    binNames{end+1} = ...
        [num2str(edges(i)) '_leq_x_lt_' num2str(edges(i+1))];    
end;
binNames{end+1} = ...
    [num2str(edges(end)) '_leq_x'];
    
% Make names legal
binNames = cellfun(@(x) ['Bin_' x], ...
                   binNames, ...
                  'UniformOutput',false);

binNames = cellfun(@(x) strrep(x, '.', 'dot'), ...
                   binNames, ...
                   'UniformOutput',false);