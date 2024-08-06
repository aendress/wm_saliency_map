function [binCounts, whichBin] = count_data_in_bin(x, nBins, minVal, maxVal, includeInf)
% [binCounts, whichBin] = count_data_in_bin(x, nBins, minVal, maxVal)
%
% Counts data points in each of nbin bins
% Arguments
%    x          input vector
%    nBins      number of bins (default: 10)
%    minVal     left boundary of bin (default: min(x))
%    maxVal     right boundary of bin (default: max(x))
% Output
%    binCounts  counts of data points in each bin
%    whichBin   index of bin in which each element of X is place

if nargin < 5
    includeInf = true;
end;


if nargin < 4
    maxVal = max(x);
end;

if nargin < 3
    minVal = min(x);
end;


if nargin < 2
    nbins = 10;
end;

if nargin < 1
    st = dbstack;
    error([st.name ': At least one argument is needed.']);
end;

edges=linspace(minVal, maxVal, nBins+1);

if includeInf
    edges = [-Inf edges Inf];
end;


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
% We thus remove the last bin


[binCounts, whichBin] = histc(x, edges);
binCounts = binCounts(1:end-1);
binCounts = array2table(binCounts, ...
    'VariableNames', ...
    get_bin_names(edges));
