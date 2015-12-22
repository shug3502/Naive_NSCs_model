function pi_hat_y =  bootstrap_particle_filter(theta, N, T, y, dt)

%Last edit 4/12/15
%Created 4/12/15
%Bootstrap particle filter for mcmc
%N number of particles
%T length of data ie length(y)
%y is observed (or synthetic) data. Matrix of size dxT.

%Requires forward_simulate_NSCs

%Notes: Needs an error measurement model. Assume this is gaussian and inpedendent on each observation.
%	Needs a prior for x0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bopts.prior_params = [12; 36]; % parameters for the prior (poisson)
bopts.error = 10;  %sigma/sd for gaussian error model. If not large enough, then filter will degenerate 
d = numel(bopts.prior_params);

%draw x0 from prior
x0 = poissrnd(repmat(bopts.prior_params,1,N),d,N);
x = zeros(d,T,N);
weights = ones(T,N);
x(:,1,:) = reshape(x0,d,1,N);

for j=2:T %loop over the time points
j
%simulate forward from the model 
for k=1:N
	x(:,j,k)  = forward_simulate_NSCs(theta, x(:,j-1,k)', dt(j-1)); % only project forward one step in time
end

%construct weights
sum(mvnpdf(reshape(x(:,j,:),d,N)',y(:,j)',bopts.error*eye(d)))
weights(j,:) = mvnpdf(reshape(x(:,j,:),d,N)',y(:,j)',bopts.error*eye(d)); %gaussian pdf
%prod(1/sqrt(2*pi*bopts.error^2)*exp(-(x(:,j,:)-repmat(y(:,j),1,1,N)).^2/(2*bopts.error^2)),1);
if max(weights(j,:))<10^-20
	error('Particle filter failed. Increase num of particles (N) or increase noise in measurement model.');
end
norm_weights(j,:) = weights(j,:)./sum(weights(j,:),2);  %may be unnecessary when using discretesample

%Resample from the weights
s = discretesample(norm_weights(j,:),N);
x(:,j,:) = x(:,j,s);
end

pi_hat_y = prod(mean(weights,2),1);
