## problem 2
# a 
for(i in 1+2:3.4*5) { print(i) }
# (-> i takes the each value- 2 and 3 (2:3) than multiplies it by 5 and adds 1 to it. This occur because of precedence of the operators)

# b
for(i in dim(matrix(0, nr=7, nc=8))) { print(i) }
# (-> i takes the value of the dimensions (7*8) of the matrix that has 7 rows and 8 columns, and the values are all 0)

# c
for(i in rnorm(3)) { print(i) }
# (-> i takes the value of three random values from the normal distribution)

# d
for(i in iris[1:3, 3]) { print(i) }
# (-> i takes the value of the first 3 instances of the 3rd attribute (Petal.Length) from the iris dataset)

# e
for(j in c(1, 2, 3, 4, 5)){ print(j) }
# (-> j takes the value of the elements in the vector defined in the for-loop with c())

# f
for(i in (function(x) {x*x}) (c(1, 2, 3))) { print(i) }
# (-> i takes the value returned by the function that takes each element in the vector defined with c() and multiplies each one by itself)

# g
for(i in NULL) { print(i) }
# (-> No output; i tries to find value in NULL, NULL has no value)

# h
for(i in strsplit(as.character(4*atan(1)), '')
    [[1]][1:10]) { print(i) }
# (-> i takes the first 10 character value of (returned by) 4*arc-tan(1), one-by-one)
