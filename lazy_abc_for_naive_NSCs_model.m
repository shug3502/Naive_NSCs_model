function lazy_abc_for_naive_NCSs_model

%last edit 26 nov 2015
%created 26 nov 2015
%Implementation of abc based inference for naive model of neural
%stem cells
%For info on lazy abc, see prangle 2015 
%Relies on sample_prior, simulate_data, my_distance_fn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use_synthetic_data=1;
real_theta = [1/(1.5); 1/(8.5)];
if use_synthetic_data
%First simulate some synthetic data
%average over 100 repeats
sz = [2,10];
synthetic_data_av = zeros(sz(1),sz(2));
N_r = 100;
parfor j=1:N_r
s = simulate_data(real_theta);
synthetic_data_av = synthetic_data_av + s;
end
data = synthetic_data_av/N_r;
else
	fprintf('check data is off correct type');
    data = [43];
end

%set params for abc
params.max_iter = 10^4;
params.R = 2; %for prior, max reaction rate

theta = zeros(2,params.max_iter);
dist = zeros(1,params.max_iter);
parfor j=1:params.max_iter
    if mod(j,1000)==0
        fprintf('Completed %d iterations \n', j);
    end
        star_theta = sample_from_prior(params.R);
        theta(:,j) = star_theta;
        D = simulate_data(star_theta);
        star_dist = my_distance_fn(D,data);        
        dist(j) = star_dist;
end
    
save('lazy_abc_out.mat','theta','dist');

abc_plotter(theta,dist,real_theta,params.R)
