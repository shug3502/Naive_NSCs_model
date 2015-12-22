function D_star = ode_solutions(time_vec,theta,initial_condition)

% last edit 26 nov 2015
% created 26 nov 2015
% takes in parameters for model
% outputs the numbers of neuroblasts, gmcs and neurons at the times in time_vec, based on solutions of the mean field equations
% can then use this to disregard unlikely parameters via lazy abc
%notation here uses a,b,c rather than b,c,d

if isempty(initial_condition)
	initial_condition = [1,6,28];
end

a = initial_condition(1)*ones(size(time_vec));  % a doesn't change according to model
b = theta(1)*a/(theta(2)).*(1-exp(-theta(2)*time_vec)) + initial_condition(2)*exp(-theta(2)*time_vec);
c = 2*theta(1)*a.*time_vec + (theta(1)*a - initial_condition(2)*theta(2))/(theta(2)).*(exp(-theta(2)*time_vec)-1) + initial_condition(3);

D_star = [a;b;c];
