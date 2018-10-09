function [steady_state,cell_pars] = give_steady_state_from_Q_constraint_and_fR_a_ratio( cell_pars , env_pars )

% find the maximum a allowing constraints to be respected
a_max = 1 - ( cell_pars.constraint.q + env_pars.ri ) / ( 1 - cell_pars.allocation.fU );
if a_max < 0
    steady_state.alpha = 0;
    return;
end

% find the a giving the desired ratio fR/a (and respecting Q constraint)
a_best = fminbnd( @(a)(costfun_Q_constraint_and_fR_a_ratio(a,cell_pars,env_pars)) , 0 , a_max);
[steady_state,cell_pars] = give_steady_state_from_a_and_Q_constraint( a_best , cell_pars , env_pars );

% check the ratio, if not met, return empty
fR = steady_state.r / (1-steady_state.a);
if abs( fR / steady_state.a - cell_pars.constraint.fR_a_ratio ) / cell_pars.constraint.fR_a_ratio > 0.01
    steady_state = [];
    return;
end
    
%     % study the function vs a to understand
%     a_max = 1 - ( cell_pars.constraint.q + env_pars.ri ) / ( 1 - cell_pars.allocation.fU );
%     a_vec = linspace(0,a_max,1000);
%     steady_states = cell(size(a_vec));
%     for i_a=1:length(a_vec)
%         steady_states{i_a} = give_steady_state_from_a_and_Q_constraint(a_vec(i_a),cell_pars,env_pars);
%     end
%     subplot(1,2,1);
%     plot( cellfun(@(x)(x.a),steady_states) , cellfun(@(x)(x.fR),steady_states) , 'b'); hold on;
%     plot( cellfun(@(x)(x.a),steady_states) , cellfun(@(x)(x.a),steady_states) .* cell_pars.constraint.fR_a_ratio , '--k'); hold on;
%     plot( steady_state.a , steady_state.fR , 'gs'); 
%     subplot(1,2,2);
%     plot( cellfun(@(x)(x.a),steady_states) , cellfun(@(x)(x.alpha),steady_states) , 'r'); hold on;
%     plot( steady_state.a , steady_state.alpha , 'gs');
%     error('did not reach the desired fR / a ratio');

end


function C = costfun_Q_constraint_and_fR_a_ratio(a,cell_pars,env_pars)
steady_state = give_steady_state_from_a_and_Q_constraint( a , cell_pars , env_pars );
fR = steady_state.r / (1-steady_state.a);
C = (fR/steady_state.a - cell_pars.constraint.fR_a_ratio )^2;
end