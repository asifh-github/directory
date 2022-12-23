# load parkinsons data
df1 = read.table("parkinsons.data", sep=',', header=TRUE, row.names=NULL)
df2 = df1[, 2:dim(df1)[2]]
# 1
# write kmedian func w/ args: 
# numeric df x(row/obs, col/dim), +ve int k(clusters), +ve int iters(iterartions)
# func: creates random centers of clusters
centers = function(x, k) {
  set.seed(123)
  return(x[sample(nrow(x), k), ])
}
# func: computes l1 distances 
l1 = function(x, center) {
  return(abs(x - center))
}
# func: kmedians 
kmedians = function(x, k, iters) {
  # get centers
  centers = centers(x, k)
  
  # get l1 distance
  
}