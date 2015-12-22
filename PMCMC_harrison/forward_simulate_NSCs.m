function xt2  = forward_simulate_NSCs(theta, xt, timestep)

%Last edit 4/12/15
%Created 4/12/15
%forward simulate the markov process using the gillespie algorithm
%xt state at time t. Assume this is a row vector.
%theta model parameters
%timestep difference in time until next read out taken

%Output: xt2 state at nect timepoint

%Notes: set up for gillespie simulation of simple NSCs model
%To change for another stochastic kinetics model, edit nu and reactions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = 0;
x = xt; %initialise

while time < timestep
	nu = [theta(1); x(1)*theta(2)]; %propensities
	reactions = [1, 0; -1, 2]; %updates for each reaction
	propensity = sum(nu);

	rr = rand(1);
	tau = -1/propensity*log(rr); %calculate time to next reaction
	time = time+tau;
	if time > timestep
		break
	end
	react_ind = discretesample(nu./propensity,1); %calculate index of next reaction
	x = x + reactions(react_ind,:); %update species numbers
end

xt2 = x;
