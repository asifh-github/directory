print('---Linear Regression---\n')
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import KFold 
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import make_column_transformer, TransformedTargetRegressor
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.linear_model import LinearRegression
from sklearn.feature_selection import SelectKBest, f_regression
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

# read data from csv using pandas
myData = pd.read_csv('/Users/asifh/Documents/cmpt310/Coding_Assignment_#1/Data/Student-Data/student-mat.csv', sep=';')
print('***DATA TYPES***')
print(myData.dtypes)
print('***done***\n\n')

# seperate catagoric & numeric columns
cat_cols = ['school', 'sex', 'address', 'famsize', 'Pstatus', 'Mjob', 'Fjob', 'reason', 'guardian', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic']
print('***CATAGORIC COLUMNS***')
print(cat_cols)
print('***done***\n')
num_cols = ['age', 'Medu', 'Fedu', 'traveltime', 'studytime', 'failures', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences', 'G1', 'G2', 'G3']
print('***NUMERIC COLUMNS***')
print(num_cols)
print('***done***\n')

# preprocessor: one_hot_encode catagoric data & scale numeric data
preprocessor = make_column_transformer(
    (OneHotEncoder(drop='if_binary'), cat_cols),
    (StandardScaler(), num_cols[:15]),
    remainder='passthrough'
    )
print('***PREPROCESS***')
print(preprocessor)
print('***done***\n')

# select features
X = myData.iloc[:395, :32]  # all excluding G3 
print('***FEATURES***')
print(X)
print('***done***\n')

# select target(s)
y = myData.iloc[:395, 32:33]
print('***TARGETS***')   # G3
print(y)
print('***done***\n')

# cross-validation
# k-folds
cv = KFold(n_splits=5, shuffle=True)  # better result w/ shuffle
 
# split training & testing sets (5-folds)
print('CV: k-fold\n')
for train, test in cv.split(X):
    X_train, X_test = X.iloc[train], X.iloc[test]
    y_train, y_test = y.iloc[train], y.iloc[test]
    print('\n*X_train:*\n', X_train, '\n*X_test:*\n', X_test)
    print('\n*y_train:*\n', y_train, '\n*y_true:*\n', y_test)
print('***done***\n')

# feature selection pipe
pipe_f =  make_pipeline(preprocessor,
                        SelectKBest(score_func=f_regression, k=1))     #select_k_best, k=1

# select learner model
# use make_pipe_line: 
model = make_pipeline(preprocessor,     # preprocessor
                      TransformedTargetRegressor(
                          regressor=LinearRegression())     # choose a model~~~
                      )

# fit data in model
#
X_train_selected = pipe_f.fit_transform(X_train, y_train)
model.fit(X_train_selected, y_train)

# predict G3 using model
X_test_selected = pipe_f.fit_transform(X_test, y_test)
y_pred = model.predict(X_test_selected)   
print('\n*Prediction*')
print(y_pred)

# visualization of data
# mean squared error & mean absolute error
print('\n*Mean Square Error (L2): %.2f' % mean_squared_error(y_test, y_pred))
print('\n*Mean Absolute Error (L1): %.2f' % mean_absolute_error(y_test, y_pred))
# coefficient of determination/R2: 1 is perfect 
print('\n*R2 Score(Coefficient of determination): %.2f' % r2_score(y_test, y_pred))

# output plot
plt.scatter(X_test, y_test, color='black') 
plt.plot(X_test, y_pred, color='blue', marker='o', linewidth=2, markersize=3)
 
plt.title('Graph')
plt.xticks(())
plt.yticks(())

plt.show()



