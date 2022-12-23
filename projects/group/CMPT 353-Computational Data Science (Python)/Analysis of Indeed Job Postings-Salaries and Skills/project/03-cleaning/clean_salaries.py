import pandas as pd

def clean_salaries(df):
    df = df.copy()
    low = df['salary_low'].str.replace(r'\$', '')
    low = low.str.replace(r'(,|\.\d+)', '')
    low = low.str.replace(r'K', '000')
    df['salary_low'] = pd.to_numeric(low)
    high = df['salary_high'].str.replace(r'\$', '')
    high = high.str.replace(r'(,|\.\d+)', '')
    high = high.str.replace(r'K', '000')
    df['salary_high'] = pd.to_numeric(high)
    df['salary_avg'] = (df.salary_high + df.salary_low)/2
    return df