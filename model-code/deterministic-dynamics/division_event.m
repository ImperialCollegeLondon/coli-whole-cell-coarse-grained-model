function [ value , isterminal , direction ] = division_event( ~ , y , X_div )

value = y(7) - X_div; % compare X with X_div;
isterminal = 1;
direction = 0;

end

