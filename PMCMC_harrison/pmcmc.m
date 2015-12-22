function theta = pmcmc(N)
%Last edit 4/12/15
%Created 4/12/15

%implement the particle mcmc to infer the parameters of our model. Model could be changed. Here stochastic NSCs model
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('generating noisy data \n');
%generate synthetic, noisy data
real_params = [1/1.5,1/8.5];
x0 = [12,36];
timepoints = 0:12;
noise=1;
synthetic_data = generate_synthetic_data(real_params,x0,timepoints,noise)
fprintf('Done\n');

fprintf('Initialising......\n');
mcmc.thin = 2; %thining
mcmc.burn = 10^3;
mcmc.K = 10^4;
mcmc.sigma = 0.1; %variance of r-w proposal. Should set this via a trial run
mcmc.init = [1,1];
mcmc.N = N;
mcmc.prior = [-3,4];

%initialise parameters
theta = zeros(mcmc.K,numel(real_params));
pi_hat_stored = zeros(mcmc.K);

theta(1,:) = mcmc.init;
%NB use exp(theta) as using to simulate, while otherwise RW on log(theta)
pi_hat_stored(1) = bootstrap_particle_filter(exp(theta(1,:)), mcmc.N, size(synthetic_data,2), synthetic_data, timepoints );

fprintf('Now running M-H.....\n');
ii=1 %number of accepted samples
while ii<mcmc.K
	%propose new value of theta
	theta_prop = theta(ii,:) + mcmc.sigma*randn(size(real_params));	

	%run particle filter
	pi_hat_prop =  bootstrap_particle_filter(exp(theta_prop), mcmc.N, size(synthetic_data,2), synthetic_data, timepoints);

	%check whether to accept	
	prior_support = prod((theta>mcmc.prior(1))&(theta<mcmc.prior(2))); %is theta within the prior
	u=rand(1);
	if u<pi_hat_prop/pi_hat_stored(ii) && prior_support
		%then accept the proposal
		ii=ii+1
		theta(ii,:)=theta_prop;
		pi_hat_stored(ii)=pi_hat_prop;
	else
		%reject
		ii=ii+1
		theta(ii,:)=theta(ii-1,:);
		pi_hat_stored(ii)=pi_hat_stored(ii-1);
	end

end	
fprintf('Done.\n');
save('pmcmc_theta.mat');

