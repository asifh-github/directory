import sys
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier


def main():
    month_lab = pd.read_csv(sys.argv[1])
    month_noLab = pd.read_csv(sys.argv[2])
    
    # saperate features and target in dfs: X, y 
    X = month_lab.loc[:, month_lab.columns != 'city']
    y = month_lab['city']
    # split X & y values to training and validation sets
    X_train, X_valid, y_train, y_valid = train_test_split(X, y)

    # train and validate a ml model on lablled daatset 
    model1 = make_pipeline(
        StandardScaler(),
        RandomForestClassifier(n_estimators=250, max_depth=10)
    )
    model1.fit(X_train, y_train)

    # print model's val-score
    print("Model validation score:", model1.score(X_valid, y_valid).round(3))
    
    # predict non-labelled cities in 2016 fromother dataset
    temp = month_noLab[month_noLab['year'] == 2016]
    X_test = temp.loc[:, temp.columns != 'city']
    y_test = model1.predict(X_test)

    # save to file 
    result = pd.Series(y_test)
    result.to_csv(sys.argv[3], index=False, header=False)


if __name__ == '__main__':
    main()