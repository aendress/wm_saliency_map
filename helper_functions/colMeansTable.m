function [meanTable] = colMeansTable(fullTable)

if iscell(fullTable)
    fullTable = concatenateTables(fullTable);
end;

meanTable = mean(fullTable{:,:}, 1);
meanTable = array2table(meanTable, ...
    'VariableNames', ...
    fullTable.Properties.VariableNames);
