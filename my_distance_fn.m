function dist = my_distance_fn(D1,D2)

%created 21st oct 2015
%last edit 21st oct 2015
%distance between two matrices of data
%each matrix is size 3xm where there are m time points

%scaling = repmat(IC,1,size(D1,2));
%dist = norm((D1./scaling-D2./scaling),2);  %use the 2 norm
dist = norm((D1./D2 - 1),2);   %use synthetic data to scale
