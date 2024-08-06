function make_figure(dat_cell, ylab_str, title_str, legend_str, ann_str, file_name, x_max, print_title, choosen_cols)
% make_figure(dat_cell, ylab_str, title_str, legend_str, ann_str, file_name, x_max, print_title, choosen_cols)

if nargin < 9 
    choosen_cols = 1:length(dat_cell);
end;    
if nargin < 8
    title_str = '';
else
    if ~print_title
        title_str = '';
    end;
end;
if nargin < 7
    x_max = -1;
end;
if nargin < 6
    file_name = '';
end;
if nargin < 5
    ann_str = '';
end;
if nargin < 4
    legend_str = '';
end;
if nargin < 3
    title_str = '';
end;
if nargin < 2
    ylab_str = '';
end;

if nargin < 1
    error('At least one argument is needed');
end;

%'b = .1', 'b = .15', 'b = .2',
%dat_cell = {};
%x_max = 70l
%title_str = '';
%ylab_str = '';
%ann_str = actFncText;
%file_name = ''

% Determine maximal X
if x_max < 0
    x_max = max (cellfun (@length, dat_cell));
end;

% Pad arrays
dat_cell = cellfun (@(x) [NaN(x_max - numel(x), 1); x], ...
    dat_cell, ...
    'UniformOutput', false);

dat_mat = cell2mat (dat_cell);

% Setup figure
current_fig = figure;

plot (dat_mat(:,choosen_cols), ...
    'Linewidth', 2);
set(gca,'FontSize',18)

if ~isempty(title_str)
    title(title_str, 'FontSize', 24);
end;

xlabel('Set size', 'FontSize', 20);

if ~isempty(ylab_str)
    ylabel(ylab_str, 'FontSize', 20);
end;

if ~isempty(legend_str)
    legend(legend_str(choosen_cols), 'Location', 'east', 'FontSize', 20)
end;

if ~isempty(ann_str)
    add_annotation(ann_str, 'nw', 20);
end;

if ~isempty(file_name)
    save_figure_or_wait(current_fig, file_name, true);
end;

end
