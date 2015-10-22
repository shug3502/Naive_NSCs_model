function abc_for_naive_NCSs_model

%last edit 19 oct 2015
%created 19 October 2015
%Implementation of abs based inference for naive model of neural
%stem cells
%Relies on sample_prior, simulate_data, my_distance_fn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%First simulate some synthetic data
%average over 100 repeats
real_theta = [1/(1.5); 1/(8.5)];
synthetic_data_av = 0;
for j=1:100
s = simulate_data(real_theta);
synthetic_data_av = synthetic_data_av + s;
end
synthetic_data = synthetic_data_av/1000;

%set params for abc
params.max_iter = 10^4;


theta = zeros(2,params.max_iter);
dist = zeros(1,params.max_iter);
for j=1:params.max_iter
    if mod(j,100)==0
        fprintf('Completed %d iterations \n', j);
        %save(sprintf('mcmc_output_%d.mat',j),'theta','lik_store');
    end
        star_theta = sample_from_prior;
        theta(:,j) = star_theta;
        D = simulate_data(star_theta);
        star_dist = my_distance_fn(D,synthetic_data);        
        dist(j) = star_dist;
end
    
save('abc_output_final.mat','theta','dist');

abc_plotter(theta,dist,real_theta)
