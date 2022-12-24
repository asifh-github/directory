print('---Support Vector Regression---\n')
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import KFold
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import make_column_transformer, TransformedTargetRegressor
from sklearn.pipeline import make_pipeline
from sklearn.svm import SVR
from sklearn.metrics import mean_squared_error, r2_score

# read data from csv using pandas
myData = pd.read_csv('/Users/asifh/Documents/cmpt310/Coding_Assignment_#1/Data/Student-Data/student-mat.csv', sep=';')
print('***DATA TYPES***')
print(myData.dtypes)
print('***done***\n\n')

# seperate catagoric & numeric columns
cat_cols = ['sex', 'address', 'famsize', 'Pstatus', 'Mjob', 'Fjob', 'reason', 'guardian', 'schoolsup', 'famsup', 'paid', 'activities', 'nursery', 'higher', 'internet', 'romantic']
print('***CATAGORIC COLUMNS***')
print(cat_cols)
print('***done***\n')
num_cols = ['age', 'Medu', 'Fedu', 'traveltime', 'studytime', 'failures', 'famrel', 'freetime', 'goout', 'Dalc', 'Walc', 'health', 'absences', 'G1', 'G2', 'G3']
print('***NUMERIC COLUMNS***')
print(num_cols)
print('***done***\n')

# one_hot_encode to preprocess catagoric & numeric data
preprocessor = make_column_transformer(
    (OneHotEncoder(drop='if_binary'), cat_cols), (StandardScaler(), num_cols[:15]),
    remainder='passthrough'
)
print('***PREPROCESS***')
print(preprocessor)
print('***done***\n')

# select features
# all excluding G3
X = myData.iloc[:395, 1:32]
print('\n***FEATURES***')
print(X)
print('***done***\n')

# select target(s)
# G3
y = myData.iloc[:395, 32:33]
print('\n***TARGETS***')
print(y)
print('***done***\n')

# cross-validation
# 5-folds
cv = KFold(n_splits=5)

# split training & testing sets
print('\n***K-FOLD = 5***')
for train, test in cv.split(X, y=y):
    X_train, X_test = X.iloc[train], X.iloc[test]
    y_train, y_test = y.iloc[train], y.iloc[test]
    print('\n***X_train, X_test***')
    print(X_train,'\n', X_test)
    print('\n***y_train, y_test***')
    print(y_train, '\n', y_test)
print('***done***\n')

# select learner model
# transform X to scalar
# fit data using training set
model = make_pipeline(preprocessor, TransformedTargetRegressor(
        regressor=SVR(kernel='linear'))
        )
model.fit(X_train, y_train)

#transform X_test to scalar 
# predict & print G3
y_pred = model.predict(X_test)
print('\n*Prediction*')
print(y_pred)

# visualization of data
# mean squared error
print('\n*Mean Squared Error: %.2f' % mean_squared_error(y_test, y_pred))
# coefficient of determination/R2: 1 is perfect 
print('\n*R2 Score(Coefficient of determination): %.2f' % r2_score(y_test, y_pred))

# output plot
plt.scatter(y_test, y_pred, color='black')
plt.plot(y_pred, y_pred, color='green', marker='o', linewidth=2, markersize=3)

plt.title('Graph')
plt.xticks(())
plt.yticks(())

plt.show()

