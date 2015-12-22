function wrapper(inf)

%wrapper script
%created 22/12/15
%last edit 22/12/2015
%inf is inference method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%define parameters and write these to a file so they can be read in matlab or R
params.size_theta = 2; %number of parameters theta to infer
params.size_ss = 20; %size of summary statistics
params.prop = 0.8; %percentage of data to use for training vs testing
params.filename = 'train.csv';

%write params to a file for use by R
f1=fopen('params.csv','w');
fprintf(f1,'%s, %s, %s, %s \n', 'size_theta', 'size_ss', 'prop', 'filename');
fprintf(f1,'%d,%d,%f,%s\n', params.size_theta, params.size_ss, params.prop, params.filename);
fclose('all');

seed = 197; randn('seed',seed), rand('seed',seed);

% decide which method to call based on input inf

switch inf
	case {'LiR','linear_regression'}
	% use linear regression
	% call via R
	system('Rscript ./linear_regression.r');

	case {'LoR','logistic_regression'}
	% use logistic regression
	error('Not yet implemented');

	case {'RF','random_forest'}
	% use a random forest
	%call via an R script
	system('Rscript ./linear_regression.r');

	case {'NN','neural_network'};
	% use neural network
	error('not yet implemented');
	
	case {'GP', 'gaussian_process'};
	%use a gaussian process
	%load data
	data = csvread(params.filename);
	data = data(1:10^3,:);	%NB not enough memory to run for full 10^5 size dataset
	run ~/Documents/DTC_Project1_mRNA/mRNA/inference_for_mrna/gpml-matlab-v3.6-2015-07-07/startup.m
	gaussian_process_regression(data, params);

	case {'ABC', 'knn'}
	%use ABC based on k nearest neighbours
	error('not yet implemented');

	case {'PMCMC', 'particle'}
	% use particle MCMC
	error('not yet implented');

	otherwise
	%not implement
	error('inf method not recognised');

end


