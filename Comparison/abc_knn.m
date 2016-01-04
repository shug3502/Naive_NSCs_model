function my_loss = abc_knn(data,params)
%created 22/12/15
%last edit 22/12/15

%perform abc via knn
%%%%%%%%%%%%%%%%%%%%

%load in data in train/test format
prop = params.prop;
ntr = size(data,1)*prop; nte = size(data,1)*(1-prop);                        % number of training and test points
my_loss = zeros(params.size_theta,1);

xtr = data(1:ntr,(1+params.size_theta):end); %train inputs
ytr = data(1:ntr,1:params.size_theta); %train responses
xte = data((1+ntr):(ntr+nte),(1+params.size_theta):end); %test inputs
yte = data((1+ntr):(ntr+nte),1:params.size_theta); %test responses


%X and Y have observations as rows and variables as columns
idx = knnsearch(xtr,xte,'K',params.k,'distance','euclidean');
%idx now contains indices of all nearest neighbours for each observation
%these should now be used to estimate the posterior

ypred = zeros(size(yte));
for j=1:size(xte,1) %possibly better way than a loop
temp = ytr(idx(j,:),:); %matrix k by size_ss
ypred(j,:) = mean(temp,1);
end

my_loss = mean((ypred./yte - 1).^2)'
