function [] = barFromTable(myTable, varargin)

if size(myTable,1) ~= 1
    error('We can deal only with single row tables yet');
    % we need to implement something like, but while overlaying the bars
    %bar(table2array(concatenateTables(binCounts_by_setSize_01_no_noise)))
end;


binNames = myTable.Properties.VariableNames;

binNames = cellfun(@(x) strrep(x, 'Bin_', ''), ...
    binNames, ...
    'UniformOutput',false);

binNames = cellfun(@(x) strrep(x, 'dot', '.'), ...
    binNames, ...
    'UniformOutput',false);

binNames = cellfun(@(x) strrep(x, '_leq_', '<='), ...
    binNames, ...
    'UniformOutput',false);

binNames = cellfun(@(x) strrep(x, '_lt_', '<'), ...
    binNames, ...
    'UniformOutput',false);


bar(table2array(myTable), varargin{:});
set(gca,'FontSize',14);
set(gca, 'xlim', [0 1+size(myTable,2)]);
%set(gca,'xticklabel',binNames)
xlabel('Activation',  'FontSize', 16);
ylabel('Number of Neurons', 'FontSize', 16);

xticklabel_rotate(1:length(binNames), ...
    90, ...
    binNames, ...
    'interpreter','none');

end




