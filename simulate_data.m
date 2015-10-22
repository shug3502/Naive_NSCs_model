function D = simulate_data(star_theta)

%last edit 21 oct 2015
%created 21 October 2015
%simulate data from the model using the gilespie SSA

data_time_points = [0:4:12]; %the times at which we will collect/simulate data
D = zeros(2,numel(data_time_points));

%initialise 
time = 0;
b=90;
c=100;
d=100;

for k=1:numel(data_time_points)
while time<data_time_points(k)
    %calculate propensities
    a0 = star_theta'*[b;c]; 
    rr=rand(2,1);
    tau = -1/a0*log(rr(1));
    time=time+tau;
    
    if a0*rr(2)<star_theta(1)*b
        %then neuroblast divides asymmetrically
        c = c+1;
    else
        %GMC divides symmetrically
        c = c-1;
        d = d+2;
    end

end
D(:,k) = [b; c+d]; %c+d corresponds to data where we can distinguish only between neuroblasts and other cells
end
