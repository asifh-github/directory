import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans


def get_pca(X):
    """
    Transform data to 2D points for plotting. Should return an array with shape (n, 2).
    """
    flatten_model = make_pipeline(
        MinMaxScaler(),
        PCA(2)
        
    )
    X2 = flatten_model.fit_transform(X)
    assert X2.shape == (X.shape[0], 2)
    return X2


def get_clusters(X):
    """
    Find clusters of the weather data.
    """
    model = make_pipeline(
        KMeans(n_clusters=9)
    )
    model.fit(X)
    return model.predict(X)


def main():
    # read dataset
    data = pd.read_csv(sys.argv[1])

    # separate features and target in df: X, y 
    X = data.loc[:, data.columns != 'city']
    y = data['city']
    
    # use principal component analysis to get two-dimensional data
    X2 = get_pca(X)
    # use a clustering technique to find observations with similar weather
    clusters = get_clusters(X)
    
    # plot scatter-plot of the clusters
    plt.figure(figsize=(10, 6))
    plt.scatter(X2[:, 0], X2[:, 1], c=clusters, cmap='Set1', edgecolor='k', s=30)
    plt.savefig('clusters.png')

    # print a table of how many observations from each city were put into each category 
    df = pd.DataFrame({
        'cluster': clusters,
        'city': y,
    })
    counts = pd.crosstab(df['city'], df['cluster'])
    print(counts)


if __name__ == '__main__':
    main()
