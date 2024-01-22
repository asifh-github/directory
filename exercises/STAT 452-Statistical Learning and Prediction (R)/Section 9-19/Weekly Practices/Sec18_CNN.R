#### CNN's

## To get this to work, you will need to follow the instruction
## guidelines here https://cran.r-project.org/web/packages/keras/vignettes/
## and https://tensorflow.rstudio.com/install/index.html

## If you haven't installed this this code will not work

### this is very heavy computing, it will at least make your laptop
### extremely hot and may cause it to crash!!
### do not run if you computer is not suitable for this!!!


library(keras)

###
mnist <- dataset_mnist()
names(mnist)
x_train <- mnist$train$x
g_train <- mnist$train$y
x_test <- mnist$test$x
g_test <- mnist$test$y
dim(x_train)
###
x_train <- x_train / 255
x_test <- x_test / 255
y_train <- to_categorical(g_train, 10)
dim(y_train)
###
library(jpeg)
par(mar = c(0, 0, 0, 0), mfrow = c(5, 5))
index <- sample(seq(50000), 25)
for (i in index) plot(as.raster(x_train[i,, ]))
###
model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 16, kernel_size = c(3, 3),
                padding = "same", activation = "relu",
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3),
                padding = "same", activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")


summary(model)


###

## here we actually use the cross-entropy loss as what we 
## optimize over, similar to trees

model %>% compile(loss = "categorical_crossentropy",
                  optimizer = optimizer_rmsprop(), 
                  metrics = c("accuracy"))


history <- model %>% fit(x_train, y_train,
                         epochs = 10,
                         batch_size = 128,
                         validation_split = 0.2)

accuracy <- function(pred , truth){
  mean(drop(as.numeric(pred)) == drop(truth))  
}


model %>% predict(x_test) %>% k_argmax() %>% accuracy(g_test)


### predict about 99% correctly, not bad for this, trained on a small laptop


## lets compare a random forest, 
## we need to transform the data here to make it much fit into rf
## we need a vector of x for each y, and we need y to be 
## a single categorical vector, not one-hot encoded

rf_train <- t(apply(x_train, 1, c))

library(randomForest)


### this takes about 5 minutes to run on my computer

rf_mnist <- randomForest(
  x = rf_train, y = as.factor(g_train),
  importance = FALSE, ntree = 100, mtry = 4,
  keep.forest = TRUE
)

rf_mnist

plot(rf_mnist)
## here we get a different error curve for each of the 10 categories

## get predictions from this

rf_test <- t(apply(x_test, 1, c))

rf_preds <- predict(rf_mnist, newdata = rf_test)

rf_acc <- mean(ifelse(rf_preds == g_test, yes = 1, no = 0))
rf_acc


## here a random forest still does extremely well on this problem, 
## with tuning can likely be made even better, likely almost as good
## as the CNN.

## compared to the modern machine learning problems Deep Learning is 
## used for, this probably is easy
