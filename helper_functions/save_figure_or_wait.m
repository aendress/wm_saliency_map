function save_figure_or_wait(figHandle, fileName, saveFigures, fileNamePrefix)
% save_figure_or_wait(figHandle, fileName, saveFigures, fileNamePrefix)
%
% save figure with handle figHandle if saveFigures is true or wait
% for a button or key press. file names can be prefixed with fileNamePrefix
% (c) Ansgar Endress
%

if nargin > 3
    fileName = [fileNamePrefix fileName];
end;

if nargin < 3
    saveFigures = true;
end;


    
if saveFigures
    saveas(figHandle, fileName);
else
    disp('Press any key or button to continue');
    waitforbuttonpress;
end;
    