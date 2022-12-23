import sys
import pandas as pd
import numpy as np
from scipy import stats

OUTPUT_TEMPLATE = (
    "Initial T-test p-value: {initial_ttest_p:.3g}\n"
    "Original data normality p-values: {initial_weekday_normality_p:.3g} {initial_weekend_normality_p:.3g}\n"
    "Original data equal-variance p-value: {initial_levene_p:.3g}\n"
    "Transformed data normality p-values: {transformed_weekday_normality_p:.3g} {transformed_weekend_normality_p:.3g}\n"
    "Transformed data equal-variance p-value: {transformed_levene_p:.3g}\n"
    "Weekly data normality p-values: {weekly_weekday_normality_p:.3g} {weekly_weekend_normality_p:.3g}\n"
    "Weekly data equal-variance p-value: {weekly_levene_p:.3g}\n"
    "Weekly T-test p-value: {weekly_ttest_p:.3g}\n"
    "Mann-Whitney U-test p-value: {utest_p:.3g}"
)


def main():
    reddit_counts = sys.argv[1]
    
    rc = pd.read_json(reddit_counts, lines=True)

    counts = rc.copy()
    
    # filter values in 2012 and 2013
    counts = counts[(counts['date'] >= '2012-01-01') & (counts['date'] <'2014-01-01')]
    # filter values in the /r/canada subreddit
    counts = counts[counts['subreddit'] == 'canada']
    # reset index and drop index col
    counts = counts.reset_index()
    counts = counts.drop(columns='index')
    # assign weekday values to dates
    fil_counts = counts.copy()
    fil_counts['weekday'] = fil_counts['date'].dt.dayofweek
    
    # seperate weekends in a seperate df
    weekends = fil_counts[fil_counts['weekday'] >= 5] 
    # seperate weekdays in a seperate df
    weekdays = fil_counts[fil_counts['weekday'] <= 4] 

    # do a T-test on the data to get a p-value
    initial_ttest = stats.ttest_ind(weekdays['comment_count'], weekends['comment_count'])
    # try normality test to see if the data is normally-distributed
    initial_weekday_normality = stats.normaltest(weekdays['comment_count'])
    # try normality test to see if the data is normally-distributed
    initial_weekend_normality = stats.normaltest(weekends['comment_count'])
    # check if the two data sets have equal variances
    initial_levene = stats.levene(weekdays['comment_count'], weekends['comment_count'])
    
    # skewed: transform data
    t_counts = fil_counts.copy()
    t_counts['comment_count'] = np.sqrt(t_counts['comment_count'])
    t_weekends = t_counts[t_counts['weekday'] >= 5] 
    t_weekdays = t_counts[t_counts['weekday'] <= 4] 
    
    # try normality test to see if the transformed data is normally-distributed
    transformed_weekend_normality = stats.normaltest(t_weekends['comment_count'])
    transformed_weekday_normality = stats.normaltest(t_weekdays['comment_count'])
    # check if the transformed data sets have equal variances
    transformed_levene = stats.levene(t_weekdays['comment_count'], t_weekends['comment_count'])
    
    # combine all weekdays and weekend days from each year/week pair and take the mean of their (non-transformed) counts
    f_counts = counts.copy()
    f_counts[['year', 'week', 'day']] = f_counts['date'].dt.isocalendar()
    f_weekends = f_counts[f_counts['day'] >= 6]
    f_weekends = f_weekends.groupby(by=['year', 'week']).aggregate('mean')
    f_weekends = f_weekends.drop(f_weekends.index[0])
    f_weekdays = f_counts[f_counts['day'] < 6]
    f_weekdays = f_weekdays.groupby(by=['year', 'week']).aggregate('mean')
    f_weekdays = f_weekdays.drop(f_weekdays.index[-1])
    
    # now, try normality test to see if the data is normally-distributed
    weekly_weekend_normality = stats.normaltest(f_weekends['comment_count'])
    # now, try normality test to see if the data is normally-distributed
    weekly_weekday_normality = stats.normaltest(f_weekdays['comment_count'])
    # now, check if the transformed data sets have equal variances
    weekly_levene = stats.levene(f_weekdays['comment_count'], f_weekends['comment_count'])
    # perform a T-test on the data to get a p-value
    weekly_ttest = stats.ttest_ind(f_weekdays['comment_count'], f_weekends['comment_count'])
    
    # perform a U-test on the (original non-transformed, non-aggregated) counts
    # note: do a two-sided test 
    utest = stats.mannwhitneyu(weekdays['comment_count'], weekends['comment_count'])


    print(OUTPUT_TEMPLATE.format(
        initial_ttest_p = initial_ttest.pvalue,
        initial_weekday_normality_p = initial_weekday_normality.pvalue,
        initial_weekend_normality_p = initial_weekend_normality.pvalue,
        initial_levene_p = initial_levene.pvalue,
        transformed_weekday_normality_p = transformed_weekday_normality.pvalue,
        transformed_weekend_normality_p = transformed_weekend_normality.pvalue,
        transformed_levene_p = transformed_levene.pvalue,
        weekly_weekday_normality_p = weekly_weekday_normality.pvalue,
        weekly_weekend_normality_p = weekly_weekend_normality.pvalue,
        weekly_levene_p = weekly_levene.pvalue,
        weekly_ttest_p = weekly_ttest.pvalue,
        utest_p = utest.pvalue,
    ))


if __name__ == '__main__':
    main()
