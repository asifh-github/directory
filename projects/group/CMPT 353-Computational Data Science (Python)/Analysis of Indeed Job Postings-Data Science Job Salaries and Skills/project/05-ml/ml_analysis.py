import os
import re
import sys
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import mean_absolute_error

def main(input_file):
    # read csv
    ddf = pd.read_csv(input_file)
    
    # get rid of row that has role == unidentified
    ddf = ddf[ddf['role'] != 'Unidentified']
    
    # regression to predict average salary 
    # for-regression
    print("Regression Task:")
    df = ddf.drop(['role', 'seniority'], axis=1)
    X = df.loc[:, 'is_remote':'seniority_unknown']
    X = X.drop(['role_unknown'],axis=1)
    y = df['salary_avg']
    # split X & y values to training and validation sets
    X_train, X_valid, y_train, y_valid = train_test_split(X, y)
    print("X-columns:", X_train.columns.values)
    print("y-column:", y_train.name)
    
    # random-forest
    print("\nRandom Forest (w/ 100 estimators & max_depth = 10)~")
    model = RandomForestRegressor(100, max_depth=10)
    model.fit(X_train, y_train)
    print("Model training score:", model.score(X_train, y_train).round(3))
    print("Model validation score:", model.score(X_valid, y_valid).round(3))
    print("MAD validation: ",mean_absolute_error(y_valid, model.predict(X_valid)))
    pd.DataFrame(model.predict(X_valid)).to_csv('regress_rf_predictions.csv', index=False)
              
    # gradient-boosting
    print("\nGradient Boosting (w/ 100 estimators & max_depth = 3)~")
    model = GradientBoostingRegressor(n_estimators=100, max_depth=3)
    model.fit(X_train, y_train)
    print("Model training score:", model.score(X_train, y_train).round(3))
    print("Model validation score:", model.score(X_valid, y_valid).round(3))
    print("MAD validation: ",mean_absolute_error(y_valid, model.predict(X_valid)))
    pd.DataFrame(model.predict(X_valid)).to_csv('regress_gb_predictions.csv', index=False)
              
              
    # classification to predict role 
    # for-classification
    print("\n\nClassification Task:")
    X = ddf.loc[:, 'salary_low':'is_intern']
    X['is_junior'] = ddf['is_junior']
    X['is_senior'] = ddf['is_senior']
    X['seniority_unknown'] = ddf['seniority_unknown']
    y = ddf['role']
    # split X & y values to training and validation sets
    X_train, X_valid, y_train, y_valid = train_test_split(X, y)
    print("X-columns:", X_train.columns.values)
    print("y-column:", y_train.name)
    
    # random-forest
    print("\nRandom Forest (w/ 100 estimators & max_depth = 7)~")
    model = RandomForestClassifier(100, max_depth=7)
    model.fit(X_train, y_train)
    print("Model training score:", model.score(X_train, y_train).round(3))
    print("Model validation score:", model.score(X_valid, y_valid).round(3))
    pd.DataFrame(model.predict(X_valid)).to_csv('class_rf_predictions.csv', index=False)
    
    # gradient-boosting
    print("\nGradient Boosting (w/ 100 estimators)~")
    model = GradientBoostingClassifier(n_estimators=100)
    model.fit(X_train, y_train)
    print("Model training score:", model.score(X_train, y_train).round(3))
    print("Model validation score:", model.score(X_valid, y_valid).round(3))
    pd.DataFrame(model.predict(X_valid)).to_csv('class_gb_predictions.csv', index=False)     


if __name__ == '__main__':
    input_file = sys.argv[1]
    main(input_file)