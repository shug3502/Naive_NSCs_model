function synthetic_data = generate_synthetic_data(theta,x0,timepoints,noise);
%last edit 4/12/15
%created 4/12/15
%create noisy synthetic data
%%%%%%%%%%%%%%%%%%%%%%%%

dt=diff(timepoints);
x=x0;
synthetic_data = zeros(numel(x0),numel(timepoints));
synthetic_data(:,1) = x0 + noise*randn(size(x0));

for j=1:length(dt)
	x = forward_simulate_NSCs(theta, x, dt(j));
	synthetic_data(:,1+j) = x + noise*randn(size(x));
end
