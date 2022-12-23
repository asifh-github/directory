import sys
import pandas as pd
import matplotlib.pyplot as plt

def main():

    # get filenames 
    filename1 = sys.argv[1]
    filename2 = sys.argv[2]
    
    # read csv1
    csv1 = pd.read_csv(filename1, sep=' ', header=None, index_col=1,
        names=['lang', 'page', 'views', 'bytes'])
    # read csv2
    csv2 = pd.read_csv(filename2, sep=' ', header=None, index_col=1,
        names=['lang', 'page', 'views', 'bytes'])
    
    # sort the values/views (desc) of csv1
    csv1_sorted = csv1.sort_values(['views'], ascending=False)
    
    ## distribution of views
    # plot csv1_sorted using index 0 to n-1 range
    plt.figure(figsize=(10, 5))     # change the size to something sensible
    plt.subplot(1, 2, 1)     # subplots in 1 row, 2 columns, select the first
    plt.plot(csv1_sorted['views'].values)     # plot 1
    # add title and label the axes
    plt.title("Popularity Distribution of Pages")
    plt.xlabel("Rank")
    plt.ylabel("Views")
    
    
    ## hourly views
    # create a new df containing views from csv1 & csv2 
    new_df = pd.DataFrame(data=dict(views1=csv1['views'], views2=csv2['views']))
    # plot csv1_data/views1 on x-axis $ csv2_data/views on y-axis 
    plt.subplot(1, 2, 2)     # ... and then select the second
    plt.plot(new_df['views1'], new_df['views2'], 'bo')     # plot 2
    # scale values to log scale
    plt.xscale("log")
    plt.yscale("log")
    # add title and label the axes
    plt.title("Correlation of views on pages btwn two constcutive hours")
    plt.xlabel("Hour 1 views (in log scale)")
    plt.ylabel("Hour 2 views (in log scale)")

    
    # save plots as png 
    plt.savefig('wikipedia.png') 
    
    
    
if __name__ == '__main__':
    main()
