# train logistic regression model
# read parameter inputs from file
pp <- read.csv('params.csv',header=TRUE, stringsAsFactors=FALSE)

# import data from csv file
x <- read.csv(pp$filename,header=FALSE)
n <- nrow(x)
prop <- pp$prop
prior.max <- pp$priormax
train <- x[1:(prop*n),]
test <- x[(prop*n+1):n,]
sz <- pp$size_ss # size of summary statistics
m <- pp$size_theta

#scale response for logistic regression
train[,1:m] <- train[,1:m]/prior.max

# start by fitting a simple linear model

models <- list()
responsenames <- paste("V", 1:m, sep='')
varnames <- paste("V", (m+1):(sz+m), sep='') 

for (y in responsenames){
  form <- formula(paste(y, "~ .")) #, varnames))  # varnames))
  models[[y]] <- glm(form, data=train, family = "gaussian")
  }

z <- test
for (j in 1:m){
glm.predict <- prior.max*predict(models[[responsenames[j]]],z)
 
loss <- mean((glm.predict/z[,j] - 1)^2) 

line=paste("LoR: ", loss)
print(line)
write(line,file="loss.csv",append=TRUE)
 
plot(z[,j], glm.predict,
    main="Logistic regression predictions vs actual",
    xlab="Actual")
}
#NB currently the 7th piece of info is spurious, so should not get a decent (predictive) model for that 

