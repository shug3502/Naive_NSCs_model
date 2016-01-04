# train neural network
require(nnet)
# read parameter inputs from file
pp <- read.csv('params.csv',header=TRUE, stringsAsFactors=FALSE)

# import data from csv file
x <- read.csv(pp$filename,header=FALSE)
n <- nrow(x)
ll <- pp$layers
prop <- pp$prop
train <- x[1:(prop*n),]
test <- x[(prop*n+1):n,]

sz <- pp$size_ss # size of summary statistics
m <- pp$size_theta

# start by fitting a simple linear model

models <- list()
responsenames <- paste("V", 1:m, sep='')
varnames <- paste("V", (m+1):(sz+m), sep='') 

for (y in responsenames){
  form <- formula(paste(y, "~ .")) #, varnames))  # varnames))
  models[[y]] <- nnet(form, data=train, size=ll, maxit = 1000, linout=T) 
  }

z <- test
for (j in 1:m){
nnet.predict <- predict(models[[responsenames[j]]],z)
 
loss <- mean((nnet.predict/z[,j] - 1)^2) 

line=paste("NN: ", loss)
print(line)
write(line,file="loss.csv",append=TRUE)
 
plot(z[,j], nnet.predict,
    main="Neural network predictions vs actual",
    xlab="Actual")
}
#NB currently the 7th piece of info is spurious, so should not get a decent (predictive) model for that 
