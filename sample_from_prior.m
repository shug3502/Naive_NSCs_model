function theta_0 = sample_from_prior

%last edit 19 oct 2015
%created 19 October 2015
%Samples from a noninformative prior for kinetic reaction parameters
%k_1 = Uniform(0,10^-2)
%k_2 = Uniform(0,10^-2)
R = 1; % maximum reaction rate based on observations
theta_0 = R*rand(2,1);
