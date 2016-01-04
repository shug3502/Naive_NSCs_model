function wrapper(inf_method)

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
params.k = 200; %num of nearest neighbours to use in ABC-knn
params.ntree = 40; %number of trees in random forest
params.priormax = 2; %maximum of prior parameters for logistic regression
params.layers = 40; %size of hidden layers in neural network

%write params to a file for use by R
f1=fopen('params.csv','w');
fprintf(f1,'%s, %s, %s, %s, %s, %s, %s \n', 'size_theta', 'size_ss', 'prop', 'ntree', 'priormax', 'layers', 'filename');
fprintf(f1,'%d,%d,%f,%d,%f,%d,%s\n', params.size_theta, params.size_ss, params.prop, params.ntree, params.priormax, params.layers, params.filename);
fclose('all');

seed = 197; randn('seed',seed), rand('seed',seed);

% decide which method to call based on input inf

switch inf_method
	case {'LiR','linear_regression'}
	% use linear regression
	% call via R
	system('Rscript ./linear_regression.r');

	case {'LoR','logistic_regression'}
	% use logistic regression
	%call via R
	system('Rscript ./logistic_regression.r');
	
	case {'RF','random_forest'}
	% use a random forest
	%call via an R script
	system('Rscript ./random_forest.r');

	case {'NN','neural_network'};
	% use neural network
	%call via R
	system('Rscript ./neural_net.r');
	
	case {'GP', 'gaussian_process'};
	%use a gaussian process
	%load data
	data = csvread(params.filename);
	data = data(1:10^3,:);	%NB not enough memory to run for full 10^5 size dataset
	run ~/Documents/DTC_Project1_mRNA/mRNA/inference_for_mrna/gpml-matlab-v3.6-2015-07-07/startup.m
	my_loss = gaussian_process_regression(data, params);	
	print_out_loss(inf_method,my_loss);

	case {'ABC', 'knn'}
	%use ABC based on k nearest neighbours
	data = csvread(params.filename);
	my_loss = abc_knn(data,params);
	print_out_loss(inf_method,my_loss);

	case {'PMCMC', 'particle'}
	% use particle MCMC
	error('not yet implented');

	otherwise
	%not implement
	error('inf method not recognised');

end

end

function print_out_loss(inf_method,loss)
f2 = fopen('loss.csv','a');
for i=1:length(loss)
fprintf(f2, '%s: %f\n', inf_method,loss(i))
end
fclose('all');
end
