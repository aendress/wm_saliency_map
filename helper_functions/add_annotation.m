function [textx texty] = add_annotation(annText, pos, fontSize)


if nargin < 3
    fontSize = 32;
end;

if nargin < 2
    pos = 'nw';
end;



xlim = get(gca,'xlim');
ylim = get(gca,'ylim');

switch lower(pos)
    case 'nw'
        textx = xlim(1) + (xlim(2)-xlim(1)) * .1;
        texty = ylim(2) - (ylim(2)-ylim(1)) * .1;
        
    case 'ne'
        % this won't work
        textx = xlim(2) - (xlim(2)-xlim(1)) * .1;
        texty = ylim(2) - (ylim(2)-ylim(1)) * .1;
        
        
    case 'sw'
        textx = xlim(1) + (xlim(2)-xlim(1)) * .1;
        texty = ylim(1) + (ylim(2)-ylim(1)) * .1;
        
    case 'se'
        % This won't work
        textx = xlim(2) - (xlim(2)-xlim(1)) * .1;
        texty = ylim(1) + (ylim(2)-ylim(1)) * .1;
        
        
    otherwise
        warning('Unknown position label, using default');
        textx = xlim(1) + (xlim(2)-xlim(1)) * .1;
        texty = ylim(2) - (ylim(2)-ylim(1)) * .1;
        
end;

text(textx, texty, annText, 'FontSize', fontSize, 'Interpreter','latex');

end