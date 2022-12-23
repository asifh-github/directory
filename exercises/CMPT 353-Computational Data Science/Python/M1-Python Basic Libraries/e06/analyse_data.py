import pandas as pd
from scipy import stats
from statsmodels.stats.multicomp import pairwise_tukeyhsd

def main():
    # read data from csv 
    data = pd.read_csv('data.csv')

    # do a avova test: to determine if the means of any of the groups differ
    anova = stats.f_oneway(data['qs1'], data['qs2'], data['qs3'], data['qs4'], data['qs5'], data['merge1'], data['partition_sort'])
    print('ANOVA p-value:', anova.pvalue)
    # ANOVA pvalue: 0.0 < 0.05, we can conclude that means amoung the distinct sorting algorithms differ

    # if you get significance in an ANOVA
    # do a post hoc tesh: do pairwise comparisons between each variable
    data_melt = pd.melt(data)
    posthoc = pairwise_tukeyhsd(
        data_melt['value'], data_melt['variable'],
        alpha=0.05)
    print(posthoc)
    # POST HOC analysis: looking at the results we can conclude that 'qs1' is the fastest 
    #      and we reject two pair-gorups, i.e., pair 'merge1' & 'qs5' and pair 'qs2' & 'qs3' (can not be distinguished)
    
    print("Sorting Algorihtms Rank:\n 1. qs1\n 2. qs2 and qs3\n 3. partition_sort\n 4. merge1 and qs5\n 5. qs4\n\n - Rank 2: qs2 & qs3 can not be dintinguished\n - Rank 4: merge1 & qs5 can not be dintinguished\n ")


if __name__ == '__main__':
    main()