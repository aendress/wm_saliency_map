function [bigTable] = concatenateTables(cellArrayOfTables)

if ~iscell(cellArrayOfTables)
    error('Input arguments needs to be a cell array of tables');
end;

bigTable = cellArrayOfTables{1};

for i=2:length(cellArrayOfTables)
    bigTable = [bigTable; cellArrayOfTables{i}];
end;