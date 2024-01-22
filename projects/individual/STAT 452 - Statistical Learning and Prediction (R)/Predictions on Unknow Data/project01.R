library(dplyr)
library(corrplot)
library(MASS) # for ridge
library(glmnet) # for LASSO
library(rpart) # for decision trees
library(rpart.plot)
library(randomForest) # for random forest
library(gbm) # for boosted trees

# read train dataset
df <- read.csv('training_data.csv', header=TRUE)
summary(df)
head(df)

# compute correlations
corrMatrix <- cor(select_if(df, is.numeric))
corrplot(corrMatrix, method="number", type="lower", diag=FALSE, number.cex=0.7)

plot(Y~X1, data=df)
plot(Y~X2, data=df)
plot(Y~X3, data=df)
plot(Y~X4, data=df)
plot(Y~X5, data=df)
plot(Y~X6, data=df)
plot(Y~X7, data=df)
plot(Y~X8, data=df)
plot(Y~X9, data=df)
plot(Y~X10, data=df)
plot(Y~X11, data=df)
plot(Y~X12, data=df)
plot(Y~X13, data=df)
plot(Y~X14, data=df)
plot(Y~X15, data=df)
plot(Y~X16, data=df)
plot(Y~X17, data=df)
plot(Y~X18, data=df)
plot(Y~X19, data=df)
plot(Y~X20, data=df)
plot(Y~X21, data=df)

# fit step-wise regression
initial <- lm(
  data = df,
  formula = Y ~ 1
)
final <- lm(
  data = df,
  formula = Y ~ .
)
step <- step(
  object = initial, scope = list(upper = final),
  k = log(nrow(df))
)
summary(step)
## 7 selected vars: X18, X21, X13, X8, X20,  X12, X1, & X5 ##

# fit a ridge
ridge <- lm.ridge(Y ~ ., lambda = seq(0, 100, .05), data = df)
plot(ridge)
select(ridge)
which.min(ridge$GCV)
(coef.ri.best <- coef(ridge)[which.min(ridge$GCV), ])
## lambda-man: 0.45 ##

# fit lasso
lasso <- cv.glmnet(y = as.matrix(df[, 1]), x = as.matrix(df[, c(2:22)]), 
                   family = "gaussian"
)
plot(lasso)
lasso
# lambda min
lasso$lambda.min
# lambda 1se
lasso$lambda.1se
# get the coefficient estimates
coef(lasso, s = lasso$lambda.min) 
coef(lasso, s = lasso$lambda.1se)
## 11 non-zero coef of lambda-1se (unordered): X1, X4, X5, X8, X9, X13, X14, X18, X19, X20, & X21##

# fit decision trees
tree <- rpart(Y ~ ., method = "anova", data = df, cp = 0)
cpt <- tree$cptable
plotcp(tree)
# find location of minimum error
minrow <- which.min(cpt[, 4])
# take geometric mean of cp values at min error and one step up
cplow.min <- cpt[minrow, 1]
cpup.min <- ifelse(minrow == 1, yes = 1, no = cpt[minrow - 1, 1])
cp.min <- sqrt(cplow.min * cpup.min)
# find smallest row where error is below +1SE
se.row <- min(which(cpt[, 4] < cpt[minrow, 4] + cpt[minrow, 5]))
# take geometric mean of cp values at min error and one step up
cplow.1se <- cpt[se.row, 1]
cpup.1se <- ifelse(se.row == 1, yes = 1, no = cpt[se.row - 1, 1])
cp.1se <- sqrt(cplow.1se * cpup.1se)
# do pruning each way
tree.prune.min <- prune(tree, cp = cp.min)
tree.prune.1se <- prune(tree, cp = cp.1se)
# plot tress
#prp(tree.prune.min, type = 1, extra = 1, main = "Tree pruned to Min CV Error")
#prp(tree.prune.1se, type = 1, extra = 1, main = "Tree pruned to +1SE CV Error")

# fit a random forest with only ntree
set.seed(564781)
rf <- randomForest(
  data = df, Y ~ ., ntree = 1000,
  importance = TRUE, keep.forest = TRUE
)
plot(rf, main = "OOB Error")
## 1000 trees are okay ##
# tune parameters - 1
set.seed(564781)
n <- nrow(df)
sf <- 0.1
reorder <- sample.int(n)
set <- ifelse(test = (reorder < sf * n), yes = 1, no=2)
df_small <- df[set==1,]
reps <- 3
varz <- 1:10
nodez <- c(1, 3, 5, 7, 10, 15, 20)
NS <- length(nodez)
M <- length(varz)
rf.oob <- matrix(NA, nrow = M * NS, ncol = reps)
for (r in 1:reps) {
  counter <- 1
  for (m in varz) {
    for (ns in nodez) {
      rfm <- randomForest(
        data = df_small, Y ~ ., ntree = 1000,
        mtry = m, nodesize = ns
      )
      rf.oob[counter, r] <- mean((predict(rfm) - df_small$Y)^2)
      counter <- counter + 1
    }
  }
}
parms <- expand.grid(nodez, varz)
row.names(rf.oob) <- paste(parms[, 2], parms[, 1], sep = "|")
mean.oob <- apply(rf.oob, 1, mean)
min.oob <- apply(rf.oob, 2, min)
boxplot(rf.oob, use.cols = FALSE, las = 2)
boxplot(t(rf.oob) / min.oob,
        use.cols = TRUE, las = 2,
        main = "RF Tuning Variables and Node Sizes")
beepr :: beep()
## worst: varz > 6 ##
## worst: nodez < 10 ##
## best: 10|3 ##
# tune paramaeter - 2
set.seed(564781)
n <- nrow(df)
sf <- 0.15
reorder <- sample.int(n)
set <- ifelse(test = (reorder < sf * n), yes = 1, no=2)
df_small <- df[set==1,]
reps <- 5
varz <- 6:10
nodez <- c(1, 3, 5, 7, 10)
NS <- length(nodez)
M <- length(varz)
rf.oob <- matrix(NA, nrow = M * NS, ncol = reps)
for (r in 1:reps) {
  counter <- 1
  for (m in varz) {
    for (ns in nodez) {
      rfm <- randomForest(
        data = df_small, Y ~ ., ntree = 1000,
        mtry = m, nodesize = ns
      )
      rf.oob[counter, r] <- mean((predict(rfm) - df_small$Y)^2)
      counter <- counter + 1
    }
  }
}
parms <- expand.grid(nodez, varz)
row.names(rf.oob) <- paste(parms[, 2], parms[, 1], sep = "|")
mean.oob <- apply(rf.oob, 1, mean)
min.oob <- apply(rf.oob, 2, min)
boxplot(rf.oob, use.cols = FALSE, las = 2)
boxplot(t(rf.oob) / min.oob,
        use.cols = TRUE, las = 2,
        main = "RF Tuning Variables and Node Sizes")
beepr :: beep()
## worst: varz > 8 ##
## worst: nodez < 7 ##
## best: 10|3 ##
# tune paramaeter - 3
set.seed(564781)
n <- nrow(df)
sf <- 0.20
reorder <- sample.int(n)
set <- ifelse(test = (reorder < sf * n), yes = 1, no=2)
df_small <- df[set==1,]
reps <- 5
varz <- 8:10
nodez <- 1:6
NS <- length(nodez)
M <- length(varz)
rf.oob <- matrix(NA, nrow = M * NS, ncol = reps)
for (r in 1:reps) {
  counter <- 1
  for (m in varz) {
    for (ns in nodez) {
      rfm <- randomForest(
        data = df_small, Y ~ ., ntree = 1000,
        mtry = m, nodesize = ns
      )
      rf.oob[counter, r] <- mean((predict(rfm) - df_small$Y)^2)
      counter <- counter + 1
    }
  }
}
parms <- expand.grid(nodez, varz)
row.names(rf.oob) <- paste(parms[, 2], parms[, 1], sep = "|")
mean.oob <- apply(rf.oob, 1, mean)
min.oob <- apply(rf.oob, 2, min)
boxplot(rf.oob, use.cols = FALSE, las = 2)
boxplot(t(rf.oob) / min.oob,
        use.cols = TRUE, las = 2,
        main = "RF Tuning Variables and Node Sizes")
beepr :: beep()
## best_1: 10|4 ##
## best_2: 10|2 ##
# fit a random forest with best params
rf <- randomForest(
  data = df, Y ~ .,
  ntree = 1000, mtry = 10, nodesize = 4,
  importance = TRUE, keep.forest = TRUE
)
plot(rf, main = "OOB Error")
importance(rf)
varImpPlot(rf, main = "RF Variable Importance Plots")
## imp vars: 9; X8, X21, X18, X12, X20, X1, X11, X13, & X5 ##

# fit a boosted trees with only n.trees
set.seed(564781)
bt <- gbm(
  data = df, Y ~ ., distribution = "gaussian",
  n.trees = 10000
)
gbm.perf(bt, method = "OOB", oobag.curve = TRUE)
## 10000 trees are okay ##
# tune parameters - 1
set.seed(564781)
n <- nrow(df)
sf <- 0.10
reorder <- sample.int(n)
set <- ifelse(test = (reorder < sf * n), yes = 1, no=2)
df_small <- df[set==1,]
V <- 2
R <- 2
n2 <- nrow(df_small)
folds <- matrix(NA, nrow = n2, ncol = R)
for (r in 1:R) {
  folds[, r] <- floor((sample.int(n2) - 1) * V / n2) + 1
}
shr <- c(.001, .005, .025, .125)
dep <- 1:5
trees <- 10000
NS <- length(shr)
ND <- length(dep)
gb.cv <- matrix(NA, nrow = ND * NS, ncol = V * R)
opt.tree <- matrix(NA, nrow = ND * NS, ncol = V * R)
qq <- 1
for (r in 1:R) {
  for (v in 1:V) {
    train <- df_small[folds[, r] != v, ]
    test <- df_small[folds[, r] == v, ]
    counter <- 1
    for (d in dep) {
      for (s in shr) {
        btm <- gbm(
          data = train, Y ~ ., distribution = "gaussian",
          n.trees = trees, interaction.depth = d, shrinkage = s
        )
        treenum <- min(trees, 2 * gbm.perf(btm, method = "OOB", 
                                           plot.it = FALSE))
        opt.tree[counter, qq] <- treenum
        preds <- predict(btm, newdata = test, n.trees = treenum)
        gb.cv[counter, qq] <- mean((preds - test$Y)^2)
        counter <- counter + 1
      }
    }
    qq <- qq + 1
  }
}
parms <- expand.grid(shr, dep)
row.names(gb.cv) <- paste(parms[, 2], parms[, 1], sep = "|")
row.names(opt.tree) <- paste(parms[, 2], parms[, 1], sep = "|")
opt.tree
gb.cv
(mean.tree <- apply(opt.tree, 1, mean))
(mean.cv <- sqrt(apply(gb.cv, 1, mean)))
min.cv <- apply(gb.cv, 2, min)
boxplot(sqrt(gb.cv), use.cols = FALSE, las = 2)
boxplot(sqrt(t(gb.cv) / min.cv),
        use.cols = TRUE, las = 2,
        main = "GBM Fine-Tuning Variables and Node Sizes"
)
beepr :: beep()
## worst: dep > 3 ##
## worst: shr <= 0.125 ##
## best: 5|0.025 ##
# tune parameters - 2
set.seed(564781)
n <- nrow(df)
sf <- 0.20
reorder <- sample.int(n)
set <- ifelse(test = (reorder < sf * n), yes = 1, no=2)
df_small <- df[set==1,]
V <- 2
R <- 3
n2 <- nrow(df_small)
folds <- matrix(NA, nrow = n2, ncol = R)
for (r in 1:R) {
  folds[, r] <- floor((sample.int(n2) - 1) * V / n2) + 1
}
shr <- c(.001, .005, .025, .05, .075, .01)
dep <- 3:8
trees <- 10000
NS <- length(shr)
ND <- length(dep)
gb.cv <- matrix(NA, nrow = ND * NS, ncol = V * R)
opt.tree <- matrix(NA, nrow = ND * NS, ncol = V * R)
qq <- 1
for (r in 1:R) {
  for (v in 1:V) {
    train <- df_small[folds[, r] != v, ]
    test <- df_small[folds[, r] == v, ]
    counter <- 1
    for (d in dep) {
      for (s in shr) {
        btm <- gbm(
          data = train, Y ~ ., distribution = "gaussian",
          n.trees = trees, interaction.depth = d, shrinkage = s
        )
        treenum <- min(trees, 2 * gbm.perf(btm, method = "OOB", 
                                           plot.it = FALSE))
        opt.tree[counter, qq] <- treenum
        preds <- predict(btm, newdata = test, n.trees = treenum)
        gb.cv[counter, qq] <- mean((preds - test$Y)^2)
        counter <- counter + 1
      }
    }
    qq <- qq + 1
  }
}
parms <- expand.grid(shr, dep)
row.names(gb.cv) <- paste(parms[, 2], parms[, 1], sep = "|")
row.names(opt.tree) <- paste(parms[, 2], parms[, 1], sep = "|")
opt.tree
gb.cv
(mean.tree <- apply(opt.tree, 1, mean))
(mean.cv <- sqrt(apply(gb.cv, 1, mean)))
min.cv <- apply(gb.cv, 2, min)
boxplot(sqrt(gb.cv), use.cols = FALSE, las = 2)
boxplot(sqrt(t(gb.cv) / min.cv),
        use.cols = TRUE, las = 2,
        main = "GBM Fine-Tuning Variables and Node Sizes"
)
beepr :: beep()
## best_1: 8|0.001 ##
## best_2 : 8|0.025 ##
# fit a boosted trees with best params
bt <- gbm(
  data = df, Y ~ ., distribution = "gaussian",
  n.trees = 10000, interaction.depth = 8, shrinkage = 0.001,
  bag.fraction = 0.8
)
gbm.perf(bt, method = "OOB", oobag.curve = TRUE)
summary(bt)
## imp vars: 9; X18, X21, X8, X12, X13, X11, X20, X1, & X5 ##

############### cross-validation of all models with tuned params ###############
set.seed(564781)
# set number of folds
V <- 5
# sample the folds
n = nrow(df)
folds <- floor((sample.int(n) - 1) * V / n) + 1
# create matrix for MSPEs for 7 models
MSPEs.cv <- matrix(NA, nrow = V, ncol = 11)
colnames(MSPEs.cv) <- c("LS", "Hybrid-step", "Ridge", "LASSO-min", "LASSO-1SE", 
                        "dTrees-min", "dTrees-1SE", "RandomF-1", "RandomF-2", 
                        "BoostedT-1", "BoostedT-2")
# run cross-validation in for-loop
for(v in 1:V) {
  # fit 7 models on fold == !v
  model.ls.cv <- lm(Y ~ ., data=df[folds!=v, ])
  model.step.cv <- step <- step(
    object = lm(data=df[folds!=v, ], formula = Y ~ 1), 
    scope = list(upper = lm(data=df[folds!=v, ], formula = Y ~ .)),
    k = log(nrow(df[folds!=v, ]))
  )
  model.ridge.cv <- lm.ridge(Y ~ ., lambda=seq(0, 100, .05), df[folds!=v, ])
  model.lasso.cv <- cv.glmnet(
    y = as.matrix(df[folds!=v, 1]), 
    x = as.matrix(df[folds!=v, c(2:22)]), 
    family = "gaussian"
  )
  model.tree.cv <- rpart(Y ~ ., method = "anova", data = df[folds!=v, ], cp = 0)
  cpt <- model.tree.cv$cptable
  minrow <- which.min(cpt[, 4])
  cplow.min <- cpt[minrow, 1]
  cpup.min <- ifelse(minrow == 1, yes = 1, no = cpt[minrow - 1, 1])
  cp.min <- sqrt(cplow.min * cpup.min)
  se.row <- min(which(cpt[, 4] < cpt[minrow, 4] + cpt[minrow, 5]))
  cplow.1se <- cpt[se.row, 1]
  cpup.1se <- ifelse(se.row == 1, yes = 1, no = cpt[se.row - 1, 1])
  cp.1se <- sqrt(cplow.1se * cpup.1se)
  model.tree.cv.prune.min <- prune(model.tree.cv, cp = cp.min)
  model.tree.cv.prune.1se <- prune(model.tree.cv, cp= cp.1se)
  model.rf1.cv <- randomForest(
    data = df[folds!=v, ], Y ~ .,
    nodesize = 4, ntree = 1000, mtry = 10
  )
  model.rf2.cv <- randomForest(
    data = df[folds!=v, ], Y ~ .,
    ntree = 1000, nodesize = 10, mtry = 2
  )
  model.bt1.cv <- gbm(
    data = df, Y ~ ., distribution = "gaussian",
    n.trees = 10000, interaction.depth = 8, shrinkage = 0.001
  )
  model.bt2.cv <- gbm(
    data = df, Y ~ ., distribution = "gaussian",
    n.trees = 10000, interaction.depth = 8, shrinkage = 0.025
  )
  
  # predict Ozone using the fitted models on fold == v
  pred.ls.cv <- predict(model.ls.cv, newdata=df[folds==v, ])
  pred.step.cv <- predict(model.step.cv, newdata=df[folds==v, ])
  pred.ridge.cv <- as.matrix(cbind(1, df[folds==v, 2:22])) %*% 
    coef(model.ridge.cv)[which.min(model.ridge.cv$GCV), ]
  pred.lasso.min.cv <- predict(model.lasso.cv, newx=as.matrix(df[folds==v, c(2:22)]), 
                               s=model.lasso.cv$lambda.min)
  pred.lasso.1se.cv <- predict(model.lasso.cv, newx=as.matrix(df[folds==v, c(2:22)]), 
                               s=model.lasso.cv$lambda.1se)
  pred.tree.min.cv <- predict( model.tree.cv.prune.min, newdata=df[folds==v, ])
  pred.tree.1se.cv <- predict( model.tree.cv.prune.1se, newdata=df[folds==v, ])
  pred.rf1.cv <- predict( model.rf1.cv, newdata=df[folds==v, ])
  pred.rf2.cv <- predict( model.rf2.cv, newdata=df[folds==v, ])
  pred.bt1.cv <- predict( model.bt1.cv, newdata=df[folds==v, ])
  pred.bt2.cv <- predict( model.bt2.cv, newdata=df[folds==v, ])
  
  # calculated MSPEs for 7 models for each v fold
  MSPEs.cv[v, 1] <- mean((df[folds==v, "Y"] - pred.ls.cv)^2)
  MSPEs.cv[v, 2] <- mean((df[folds==v, "Y"] - pred.step.cv)^2)
  MSPEs.cv[v, 3] <- mean((df[folds==v, "Y"] - pred.ridge.cv)^2)
  MSPEs.cv[v, 4] <- mean((df[folds==v, "Y"] - pred.lasso.min.cv)^2)
  MSPEs.cv[v, 5] <- mean((df[folds==v, "Y"] - pred.lasso.1se.cv)^2)
  MSPEs.cv[v, 6] <- mean((df[folds==v, "Y"] - pred.tree.min.cv)^2)
  MSPEs.cv[v, 7] <- mean((df[folds==v, "Y"] - pred.tree.1se.cv)^2)
  MSPEs.cv[v, 8] <- mean((df[folds==v, "Y"] - pred.rf1.cv)^2)
  MSPEs.cv[v, 9] <- mean((df[folds==v, "Y"] - pred.rf2.cv)^2) 
  MSPEs.cv[v, 10] <- mean((df[folds==v, "Y"] - pred.bt1.cv)^2) 
  MSPEs.cv[v, 11] <- mean((df[folds==v, "Y"] - pred.bt2.cv)^2) 
} 
# get the MSPEs for each 5 folds
MSPEs.cv
# get the mean MSPEs
(MSPEcv <- apply(X = MSPEs.cv, MARGIN = 2, FUN = mean))
# create boxplots for MSPEs
boxplot(MSPEs.cv, main = "MSPE \n Cross-Validation")
# create boxplots for relative MSPEs
low.cv <- apply(MSPEs.cv, 1, min)
boxplot(MSPEs.cv / low.cv,
        las = 2,
        main = "Relative MSPE \n Cross-Validation"
)
beepr :: beep()
## best: bt-2 ## 
########################## end of cross-validation #############################

set.seed(564781)
# fit boosted trees using full train dataset with best params
bt.main <- gbm(
  data = df, Y ~ ., distribution = "gaussian",
  n.trees = 10000, interaction.depth = 8, shrinkage = 0.025
)
summary(bt.main)
# read the test dataset
df2 <- read.csv('test_predictors.csv', header=TRUE)
# get predictions
predictions <- predict(bt.main, newdata=df2)
# save predictions
write.table(predictions,
            "proj01_test_preds.csv",
            row.names=FALSE,
            col.names=FALSE
)
beepr :: beep()