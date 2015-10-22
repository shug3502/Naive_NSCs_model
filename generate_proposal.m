function star_theta = generate_proposal(prev_theta)

%last edit 19 oct 2015
%created 19 October 2015
%Samples from a local gaussian to generate new proposal parameters

R=10^-2;
bandwidth = 10^-5;
star_theta = prev_theta + bandwidth*randn(2,1);

k=0;
while (star_theta<0) | (star_theta>R) %pick again if outside the prior
    star_theta = prev_theta + bandwidth*randn(2,1);
    k=k+1;
    if k>1000
        error('Stuck in infinite loop. Bad selection of prior or proposal');
    end
end
