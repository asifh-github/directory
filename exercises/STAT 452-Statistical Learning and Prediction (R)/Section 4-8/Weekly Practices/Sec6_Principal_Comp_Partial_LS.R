#########################################################################
# Principal Components on Prostate Data
# Partial Least Squares

prostate <- read.table("Datasets/Prostate.csv",
  header = TRUE, sep = ",", na.strings = " "
)
head(prostate)


###############################################################
## Principal Component Analysis analysis via stats::prcomp()
## Uses singular value decomposition on X instead of eigen-decomposition
##   on X'X for efficiency.  [princomp() uses eigen on X'X]
##  Default is to work with un-standardized data; scale.=TRUE fixes this
###############################################################

pc <- prcomp(x = prostate[, 2:9], scale. = TRUE)
summary(pc)

# Default plot is a scree plot as a histogram (why???)
# I'll make my own using points
plot(pc)

evals <- pc$sdev^2
csum <- cumsum(evals)
par(mfrow = c(1, 2))
plot(
  y = evals, x = c(1:(ncol(prostate) - 1)), xlab = "PC#",
  main = "Variance explained by PCA", ylab = "Variance Explained"
)
abline(a = 0, b = 0)
abline(a = 1, b = 0)

plot(
  y = c(0, csum / max(csum)), x = c(0:(ncol(prostate) - 1)),
  xlab = "PC#", ylim = c(0, 1),
  main = "Cumulative Variance explained by PCA", ylab = "Pct Explained"
)

# Look at eigenvectors to see how variables contribute to PC's
pc$rotation

############################################################
# Partial Least Squares Regression using plsr() from the pls package.
#   The code is pretty similar to lm() except that I can tell it
#   (a) Max number of components in model
#   (b) The option to use validation to choose number of components
#       "validation=" can use "none", "CV", or "LOO" (leave one out CV)
#        If "CV" is used, V=10 unless changed with "segments="

library(pls)

mod.pls <- plsr(lpsa ~ ., data = prostate, ncomp = 8, validation = "CV")
summary(mod.pls)

validationplot(mod.pls)

## same plot, with more information

plot(RMSEP(mod.pls), legend = "topright")
