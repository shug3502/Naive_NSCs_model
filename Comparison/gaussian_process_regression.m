function gaussian_process_regression(data,params)
% demonstrate usage of regression
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch 2013-10-16.
%edited JH 22/12/15

%% SAY WHICH CODE WE WISH TO EXERCISE
id = [1,4];

%seed = 197; randn('seed',seed), rand('seed',seed)


%data = csvread('train2.csv');
prop = params.prop;
ntr = size(data,1)*prop; nte = size(data,1)*(1-prop);                        % number of training and test points
for response_ind = 1:params.size_theta

xtr = data(1:ntr,params.size_theta:end);
sn = 0.2;
ytr = data(1:ntr,response_ind);
xte = data((1+ntr):(ntr+nte),params.size_theta:end);
yte = data((1+ntr):(ntr+nte),response_ind);

cov = {@covSEiso}; sf = 1; ell = 0.4;                             % setup the GP
hyp0.cov  = log([ell;sf]);
mean = {@meanSum,{@meanLinear,@meanConst}}; a = 0; b = 1;       % m(x) = a*x+b
hyp0.mean = [a*zeros(1+params.size_ss,1);b];

lik_list = {'likGauss','likLaplace','likSech2','likT'};   % possible likelihoods
inf_list = {'infExact','infLaplace','infEP','infVB','infKL'};   % inference algs

Ncg = 50;                                   % number of conjugate gradient steps
sdscale = 0.5;                  % how many sd wide should the error bars become?
col = {'k',[.8,0,0],[0,.5,0],'b',[0,.75,.75],[.7,0,.5]};                % colors
ymu{1} = yte; ys2{1} = sn^2; nlZ(1) = -Inf;
for i=1:size(id,1)
  lik = lik_list{id(i,1)};                                % setup the likelihood
  if strcmp(lik,'likT')
    nu = 4;
    hyp0.lik  = log([nu-1;sqrt((nu-2)/nu)*sn]);
  else
    hyp0.lik  = log(sn);
  end
  inf = inf_list{id(i,2)};
  fprintf('OPT: %s/%s\n',lik_list{id(i,1)},inf_list{id(i,2)})
  if Ncg==0
    hyp = hyp0;
  else
    hyp = minimize(hyp0,'gp', -Ncg, inf, mean, cov, lik, xtr, ytr); % opt hypers
  end
  [ymu{i+1}, ys2{i+1}] = gp(hyp, inf, mean, cov, lik, xtr, ytr, xte);  % predict
  [nlZ(i+1)] = gp(hyp, inf, mean, cov, lik, xtr, ytr);
end

figure, hold on
plot(ymu{1},ymu{2},'bo'),xlabel('y actual'),ylabel('y predicted');
plot(ymu{1},ymu{1},'k--');
print(sprintf('gpregress%d',response_ind),'-dpng');
end
