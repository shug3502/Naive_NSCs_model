function log_lik = calculate_likelihood(data,opts)

%last edit 19 oct 2015
%created 19 October 2015
%Calculate the likelihood by solving the master equation directly
%(numerically)
%Is a function of data
%Conditioned on a set of parameters contained in opts struct: 
%opts.k1, opts.k2, opts.n1_0, opts.n2_0, opts.n3_0

if isempty(data)
data.timestep = 1; 
data.finaltime = 2; %20 hours - length of expt
end

%set time discretisation
dt = data.timestep/10; %take a finer timestep for evaluating master equation than used to collect experimental data
t_discrete = 0:dt:data.finaltime; %time discretisation

%initialise
max_cells = 101; %assume no more than 200 cells of each type
p = zeros(max_cells,max_cells,max_cells,numel(t_discrete));
p(opts.n1_0,opts.n2_0,opts.n3_0,1) = 1; %initially we know IC

p(1:max_cells,2:(max_cells-1),3:max_cells,2:end) = ...
    p(1:max_cells,2:(max_cells-1),3:max_cells,1:(end-1)) ...
    + dt*opts.k1*repmat((1:max_cells)',1,max_cells-2,max_cells-2,numel(t_discrete)-1).*p(1:max_cells,1:(max_cells-2),3:max_cells,1:(end-1)) ...
    - dt*opts.k1*repmat((1:max_cells)',1,max_cells-2,max_cells-2,numel(t_discrete)-1).*p(1:max_cells,2:(max_cells-1),3:max_cells,1:(end-1)) ...
    + dt*opts.k2*repmat(3:max_cells,max_cells,1,max_cells-2,numel(t_discrete)-1).*p(1:max_cells,3:max_cells,1:(max_cells-2),1:(end-1)) ...
    - dt*opts.k2*repmat(2:(max_cells-1),max_cells,1,max_cells-2,numel(t_discrete)-1).*p(1:max_cells,2:(max_cells-1),3:max_cells,1:(end-1));
%solve master equation numerically via forward euler method

%plus edge cases HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if p(data.n1,data.n2,data.n3,1+round(data.t/dt))<0
    error('The likelihood we want is negative');
end
log_lik = log(p(data.n1,data.n2,data.n3,1+round(data.t/dt)));

