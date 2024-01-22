library(ROCR)
library(pROC)
library(glmnet)
library(tidyverse)
library(randomForest)
# data from: https://archive.ics.uci.edu/dataset/15/breast+cancer+wisconsin+original
# read data and clean the data
cancer <- read.csv("breast-w.csv", header=TRUE)
#dim(cancer)
cancer2 <- na.omit(cancer)
#dim(cancer2)
#head(cancer2)
cancer2$Class <- as.factor(cancer2$Class)
#summary(cancer2)
# set seed
set.seed(4099183)
# set sampling fraction
n <- nrow(cancer2)
sf <- 0.70
# generate sample
reorder <- sample.int(n)
set <- ifelse(test = (reorder < sf * n), yes = 1, no=2)
## Section 1
# fit lasso version of logistic regression 
model.logit.cv <- cv.glmnet(
  x = as.matrix(cancer2[set==1, 1:9]),
  y = cancer2[set==1, 10], family = "binomial")
#coef(logit.cv, s = model.logit.cv$lambda.min)
# predict probabilities using lamda-min
logit.pred.test <- predict(model.logit.cv,
                           type = "response",
                           s = model.logit.cv$lambda.min,
                           newx = as.matrix(cancer2[set==2, 1:9]))
# compute auc of logit
auc.logit <- auc(roc(cancer2[set==2, 10], logit.pred.test[, 1]))
print(paste("The AUC of LASSO Version of Logistic Regression:", round(auc.logit, 4)))
# get the best threshold for logit
threshold.logit <- coords(roc(cancer2[set==2, 10], logit.pred.test[, 1]), "best", ret = "threshold")
print(paste("The optimal threshold for LASSO Logistic Regression:", round(threshold.logit, 4)))
# get predicted class for logit
logit.pred.class <- ifelse(logit.pred.test[, 1] > threshold.logit[, 1], "malignant", "benign")
# compute misclassification rate of logit
misclass.test.logit <- mean(ifelse(logit.pred.class == cancer2[set==2, 10], yes=0, no=1))
print(paste("The misclassification rate of LASSO Logistic Regression:", round(misclass.test.logit, 4)))

# fit random forest using default parameters 
model.rf <- randomForest(data=cancer2[set==1, ], Class ~ .)
plot(model.rf)
# predict probabilities of rf 
rf.pred.test <- predict(model.rf, newdata=cancer2[set==2, 1:9], type="vote")
# compute auc of rf
auc.rf <- auc(roc(cancer2[set==2, 10], rf.pred.test[, 2]))
print(paste("The AUC of Default Random Forest:", round(auc.rf, 4)))
# get the best threshold for rf
threshold.rf <- coords(roc(cancer2[set==2, 10], rf.pred.test[, 2]), "best", ret = "threshold")
print(paste("The optimal threshold for Default Random Forest:", round(threshold.rf, 4)))
# get predicted class for rf
rf.pred.class <- ifelse(rf.pred.test[, 2] > threshold.rf[, 1], "malignant", "benign")
# compute misclassification rate of rf
misclass.test.rf <- mean(ifelse(rf.pred.class == cancer2[set==2, 10], yes=0, no=1))
print(paste("The misclassification rate of Default Random Forest:", round(misclass.test.rf, 4)))

# plot roc curve of both models
par(mfrow = c(1, 2))
plot(performance(prediction(logit.pred.test, cancer2[set==2, 10]),"tpr","fpr"), 
     main="ROC Curve of LASSO Version of Logistic Regression\n AUC = 0.9924")
plot(performance(prediction(rf.pred.test[, 2], cancer2[set==2, 10]),"tpr","fpr"), 
     main="ROC Curve of Default Random Forest\n AUC = 0.9915")

## Section 2
# fit svm
library(e1071)
# set tuning params
C <- 1:3
K <- c("linear", "polynomial", "radial")
c_size <- length(C)
k_size <- length(K)
# set number of folds
V <- 5 
# sample the folds
df.cv = cancer2
n.cv = nrow(df.cv)
folds <- floor((sample.int(n.cv) - 1) * V / n.cv) + 1
# create matrix for misclassification rate
misclass1.cv <- matrix(NA, nrow = V, ncol = c_size*k_size)
# compute cv misclassification rate
for(v in 1:V) {
  counter = 1
  for (k in K) {
    for (c in C) {
      model.svm <- svm(x = as.matrix(df.cv[folds!=v, 1:9]), 
                       y = df.cv[folds!=v, 10],  
                       kernel = k, cost = c, probability = TRUE)
      svm.pred.test <- predict(model.svm, probability = TRUE,
                               newdata = as.matrix(df.cv[folds==v, 1:9]))
      svm.pred.test <- attributes(svm.pred.test)$probabilities
      auc.svm <- auc(roc(df.cv[folds==v, 10], svm.pred.test[, 2]))
      threshold.svm <- coords(roc(df.cv[folds==v, 10], svm.pred.test[, 2]), "best", ret = "threshold")
      svm.pred.class <- ifelse(svm.pred.test[, 2] > threshold.svm[, 1], "malignant", "benign")
      misclass.test.svm <- mean(ifelse(svm.pred.class == df.cv[folds==v, 10], yes=0, no=1))
      misclass1.cv[v, counter] <- misclass.test.svm
      counter = counter + 1
    }
  }
}
misclass1.cv
(misclass1cv <- apply(X = misclass1.cv, MARGIN = 2, FUN = mean))
# ->  best cost = 1 and kernel = poly

# set tuning params
D <- 1:10
d_size <- length(D)
# create matrix for misclassification rate
misclass2.cv <- matrix(NA, nrow = V, ncol = d_size)
# compute cv misclassification rate
for(v in 1:V) {
  counter = 1
  for (d in D) {
    model.svm <- svm(x = as.matrix(df.cv[folds!=v, 1:9]), 
                     y = df.cv[folds!=v, 10], probability = TRUE, 
                     kernel = "polynomial", cost = 1, degree = d)
    svm.pred.test <- predict(model.svm, probability = TRUE,
                             newdata = as.matrix(df.cv[folds==v, 1:9]))
    svm.pred.test <- attributes(svm.pred.test)$probabilities
    auc.svm <- auc(roc(df.cv[folds==v, 10], svm.pred.test[, 2]))
    threshold.svm <- coords(roc(df.cv[folds==v, 10], svm.pred.test[, 2]), "best", ret = "threshold")
    svm.pred.class <- ifelse(svm.pred.test[, 2] > threshold.svm[, 1], "malignant", "benign")
    misclass.test.svm <- mean(ifelse(svm.pred.class == df.cv[folds==v, 10], yes=0, no=1))
    misclass2.cv[v, counter] <- misclass.test.svm
    counter = counter + 1
  }
}
misclass2.cv
(misclass2cv <- apply(X = misclass2.cv, MARGIN = 2, FUN = mean))
# -> best degree = 3

model.svm <- svm(x = as.matrix(cancer2[set==1, 1:9]), y = cancer2[set==1, 10],  
                 kernel = "polynomial", cost = 1, degree = 3 ,probability=TRUE)
svm.pred.test <- predict(model.svm, probability = TRUE,
                         newdata = as.matrix(cancer2[set==2, 1:9]))
svm.pred.test <- attributes(svm.pred.test)$probabilities
# compute auc of svm
auc.svm <- auc(roc(cancer2[set==2, 10], svm.pred.test[, 2]))
print(paste("The AUC of SVM:", round(auc.svm, 4)))
# get the best threshold for svm
threshold.svm <- coords(roc(cancer2[set==2, 10], svm.pred.test[, 2]), "best", ret = "threshold")
print(paste("The optimal threshold for SVM:", round(threshold.svm, 4)))
# get predicted class for svm
svm.pred.class <- ifelse(svm.pred.test[, 2] > threshold.svm[, 1], "malignant", "benign")
# compute misclassification rate of svm
misclass.test.svm <- mean(ifelse(svm.pred.class == cancer2[set==2, 10], yes=0, no=1))
print(paste("The misclassification rate of SVM:", misclass.test.svm))

