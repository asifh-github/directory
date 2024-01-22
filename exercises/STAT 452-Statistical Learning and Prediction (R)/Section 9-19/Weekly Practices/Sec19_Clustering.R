### Some examples of k-means and hierarchical clustering
wheat <-  read.csv("Datasets/wheat.csv")


head(wheat)

## do clustering on the 5 numeric predictors we have here
##
wheat_x <- wheat[, 3:7]

dim(wheat_x)
## k-means without standardizing
## first just using the first 2 predictors, so we can visualize it

km_fit <- kmeans(x = wheat_x[, 1:2], centers = 2, nstart = 20)

km_fit


plot(x = wheat_x[ ,1], y = wheat_x[ , 2], col = km_fit$cluster, 
     pch = km_fit$cluster, 
     main = "First two variables in Wheat")

## add the cluster centers in blue
points(x = km_fit$centers[, 1], y = km_fit$centers[, 2], col = "blue",
       lwd = 5)


## what about if we had standardized these predictors instead?

wheat_std <- scale(wheat_x, center = TRUE, scale = TRUE)


km_fit2 <- kmeans(x = wheat_std[, 1:2], centers = 2, nstart = 20)

plot(x = wheat_std[ ,1], y = wheat_std[ , 2], col = km_fit2$cluster, 
     pch = km_fit2$cluster)

## add the cluster centers in blue
points(x = km_fit2$centers[, 1], y = km_fit2$centers[, 2], col = "blue",
       lwd = 5)

## maybe a slight difference, but similar shape overall
## much more variability on the second variable, probably
## makes sense to standardize to treat both variables equally
## this is why the centers are now not in line

## choosing K for just 2 d data
## what value of K makes sense here?
## lets try k=2 up to k=10

k_total_wss <- rep(0, 10)
k_vals <- 1:10


for(i in 1:10){
  k <- k_vals[i]
  ## fit kmeans
  fit <- kmeans(x = wheat_std[, 1:2], centers = k, nstart = 20)
  k_total_wss[i] <- fit$tot.withinss
}

plot(x = k_vals, y = k_total_wss, type = "b", xlab = "Number of Clusters",
     ylab = "Total Within Sum of Squares")

## plot decreases the most going from k=1 to k=2, indicating that number of
## clusters might be reasonable
## should repeat this for other methods also



## cluster using PCA and all the data
##

pca_data <- prcomp(x = wheat_x, scale. = TRUE)

summary(pca_data)

plot(pca_data, type = "l", main = "Variance Explained")
## as we can visualise it, lets do K-means on the first 2 components

pr_comps <- pca_data$x[, 1:2] ## first two columns

km_fit3 <- kmeans(x = pr_comps, centers = 2, nstart = 20)

plot(x = pr_comps[, 1], 
     y = pr_comps[, 2], col = km_fit3$cluster,
     pch = km_fit3$cluster)
points(x = km_fit3$centers[, 1], y = km_fit3$centers[, 2], col = "blue",
       lwd = 5)



##### Hierarchical Clustering ####
## optional below here ##
## then hierarchical clustering, trying 2 different linkages

## first we need to compute the distances between all the data
## to show this we will just use the first 20 data points

dist_wheat <- dist(wheat_x[1:20, ], method = "euclidean")

clust1 <- hclust(dist_wheat, method = "complete")

plot(clust1)

head(clust1$merge)

clust2 <- hclust(dist_wheat, method = "average")

plot(clust2)


## then show it for all data
dist_wheat_all <- dist(wheat_x, method = "euclidean")

clust_all <- hclust(dist_wheat_all, method = "complete")

plot(clust_all, labels = FALSE)


## how to choose the number of clusters in this also


## we can specify how many clusters we want with the cutree function
## this gives us the cluster each observation is in
hclusters1 <- cutree(clust_all, k = 2)

hclusters2 <- cutree(clust_all, k = 20)


## alternatively, can use this heuristic to determine the number of clusters
h_est <- mean(clust_all$height) + 3 * sd(clust_all$height)


hclusters3 <- cutree(clust_all, h = h_est)


## then compare some of the clustering from hierarchical and kmeans

table(km_fit3$cluster, hclusters1)

## note that kmeans using pca and hierarchical clustering
## cluster the data in quite different ways here.
## we have no ground truth so we can't say one is right or wrong
## note also that the labels could be swapped around here, what you care
## about is how many points are put in the same cluster by the two methods


