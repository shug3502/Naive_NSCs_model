function write_data_to_file_NSCs_model

%last edit 21 dec 2015
%created 21 dec 2015
%based on implementation of abc based inference for naive model of neural
%stem cells
%Relies on sample_prior, simulate_data, my_distance_fn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set params for abc
params.max_iter = 10^5;
params.R = 2; %for prior, max reaction rate
params.size_theta = 2; %size of theta
params.size_ss = 20; %10 time points, 2 species

theta = zeros(params.size_theta,params.max_iter);
sum_stat = zeros(params.size_ss,params.max_iter);
parfor j=1:params.max_iter
    if mod(j,1000)==0
        fprintf('Completed %d iterations \n', j);
    end
        star_theta = sample_from_prior(params.R);
        theta(:,j) = star_theta;
        D = simulate_data(star_theta);
	sum_stat(:,j) = D(:);
end
    
data = [theta',sum_stat'];

csvwrite('train.csv',data);


