function [theta,lik_store] = mcmc_for_naive_NSCs_model

%last edit 19 oct 2015
%created 19 October 2015
%Implementation of metropolis mastings algorithm for naive model of neural
%stem cells
%Relies on the functions: calculate_likelihood, generate_proposal,
%sample_from_prior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%opts.k1 = 1/(3600*1.5); %90 mins on average
%opts.k2 = 1/(3600*8.5); %8.5hrs on average
%Set inital conditions - could be via data from first image frame
opts.n1_0 = 5;
opts.n2_0 = 12;
opts.n3_0 = 30;

%params struct contains parameters for inference with mcmc
params.burn_in = 2*10^4;
params.max_iter = 10^5;

%How often is the data collected and when is final time point
data.timestep = 1; 
data.finaltime = 2; %20 hours - length of expt
%Real or synthetic data goes here
data.n1 = opts.n1_0;
data.n2 = 13;
data.n3 = 51;
data.t = 2;

theta = zeros(2,1+params.max_iter);
lik_store = zeros(params.max_iter,1);
%initialize model parameters
theta(:,1) = sample_from_prior();

%set kinetic params to calculate likelihood
opts.k1 = theta(1,1);
opts.k2 = theta(2,1);
lik_store(1) = calculate_likelihood(data,opts);

for j=1:params.max_iter
    if mod(j,1000)==0
        fprintf('Completed %d iterations \n', j);
        save(sprintf('mcmc_output_%d.mat',j),'theta','lik_store');
    end
    while 1>0
        %propose new candidate
        star_theta = generate_proposal(theta(:,j));
        
        log_lik = calculate_likelihood(data,opts);
        r = log_lik/lik_store(1);
        
        if rand(1)<min(1,r)
            %then accept proposed parameters
            theta(:,j+1) = star_theta;
            lik_store(j) = log_lik;
            break
        end
        
    end
    
end
%discard initial period
theta = theta(:,(1+params.burn_in):end);
lik_store = lik_store(params.burn_in:params.max_iter);
%save the generated parameters
save('mcmc_output_final.mat','theta','lik_store');