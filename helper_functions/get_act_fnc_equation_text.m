function [act_fnc_text] = get_act_fnc_equation_text(act_fnc_name)


switch lower(act_fnc_name)
    case 'knops'
        act_fnc_text = '$F(x) = \frac{x}{1+x}$';
        
    case 'threshold'
        act_fnc_text = ['$F(x) = \left\{\begin{array}{ll} ' ...
            '1 & x > \theta \\ ' ...
            '0 & x \leq \theta ' ...
            '\end{array}\right.$'];
        
    case 'linear'
        act_fnc_text = '$F(x) = x$';

     case 'linear_offset'
        act_fnc_text = '$F(x) = .25x + .5$';     
        
    case 'sigmoid'
        act_fnc_text = '$F(x) = \frac{1}{1 + e^{-x}} - \frac{1}{2}$';        
        
    case 'relu'
        act_fnc_text = '$F(x) = \max(0, x)$';

    case 'tanh'
        act_fnc_text = '$F(x) = \frac{e^{x} - e^{-x}}{e^{x} + e^{-x}}$';
        
    otherwise
        warning('get_act_fnc_equation_text: Unknown activation function, using default');
        act_fnc_text = '$F(x) = \frac{x}{1+x}$';
end




