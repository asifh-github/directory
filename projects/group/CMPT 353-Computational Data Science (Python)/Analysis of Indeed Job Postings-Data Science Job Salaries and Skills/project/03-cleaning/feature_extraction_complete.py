import os
import re
import sys
import pandas as pd
from bs4 import BeautifulSoup


def title_to_role(title): 
    # research
    if re.findall(r'research', title, re.IGNORECASE):
        return "Research"
    # ml-engineer
    elif re.findall(r'ml|engineer', title, re.IGNORECASE):
        return "MLEngineer"
    # data-analyst
    elif re.findall(r'analy', title, re.IGNORECASE):
        return "Analyst"
    # data-scientist
    elif re.findall(r'scien', title, re.IGNORECASE):
        return "Scientist"
    # unknowm
    else:
        return "Unidentified"    
    
def role_to_features(role):
    # reseach 
    if role == "Scientist":
        f = [1,0,0,0,0]
        return f
    # ml-engineer
    elif role == "Analyst":
        f = [0,1,0,0,0]
        return f
    # analyst 
    elif role == "MLEngineer":
        f = [0,0,1,0,0]
        return f
    # scientist
    elif role == "Research":
        f = [0,0,0,1,0]
        return f
    # unknowm
    else:
        f = [0,0,0,0,1]
        return f 
    
def title_to_seniority(title):
    # manager 
    if re.findall(r'jr|juni|associa|assist', title, re.IGNORECASE):
        return "Jr."
    # assistant
    elif re.findall(r'manage|direct|lead|sr|seni', title, re.IGNORECASE):
        return "Sr."
    else:
        return "None"
                  
def seniority_to_features(seniority):
    # manager 
    if seniority == "Sr.":
        f = [1,0,0]
        return f
    # assistant
    elif seniority == "Jr.":
        f = [0,1,0]
        return f 
    else:
        f = [0,0,1]
        return f
        
def transform_remote(remote):
    if(remote == 'Y'):
        return 1
    return 0
    
def main(input_file,output_file):
    # read input csv
    ddf = pd.read_csv(input_file)
    
    # dummy cols for role_features
    dummy_cols_1 = ['is_scientist', 'is_analyst', 'is_ml_engineer', \
                  'is_research','role_unknown']
    # dummy cols for seniority_features
    dummy_cols_2 = ['is_senior', 'is_junior', 'seniority_unknown']    

    # convert job-titles to roles then to distinct features
    title  = ddf['job_title']
    ddf['role'] = title.apply(title_to_role)
    ddf['seniority'] = title.apply(title_to_seniority) 

    # convert to role and seniority
    role_features = pd.DataFrame(columns=dummy_cols_1)
    seniority_features = pd.DataFrame(columns=dummy_cols_2)
    
    # one-hot-encode role and seniority
    result = ddf['role'].apply(role_to_features)
    # couldn't find other way to do this!! 
    for item in result.iteritems():
        temp = pd.DataFrame([item[1]], columns=['is_scientist', 'is_analyst', \
                                                'is_ml_engineer', 'is_research', \
                                                'role_unknown'])
        role_features = role_features.append(temp, ignore_index=True)
    role_features.to_csv('role_features.csv')
    
    result = ddf['seniority'].apply(seniority_to_features)
    # couldn't find other way to do this!! 
    for item in result.iteritems():
        temp = pd.DataFrame([item[1]], columns=['is_senior', 'is_junior', \
                                                'seniority_unknown'])
        seniority_features = seniority_features.append(temp, ignore_index=True)
    seniority_features.to_csv('seniority_features.csv')
    
    # add new features to df
    ddf['is_scientist'] = role_features['is_scientist']
    ddf['is_analyst'] = role_features['is_analyst']
    ddf['is_ml_engineer'] = role_features['is_ml_engineer']
    ddf['is_research'] = role_features['is_research']
    ddf['role_unknown'] = role_features['role_unknown']
    
    ddf['is_junior'] = seniority_features['is_junior']
    ddf['is_senior'] = seniority_features['is_senior']
    ddf['seniority_unknown'] = seniority_features['seniority_unknown']
    
    # convert salary cols to numeric
    low = ddf['salary_low'].str.replace(r'\$', '')
    low = low.str.replace(r'(,|\.\d+)', '')
    low = low.str.replace(r'K', '000')
    ddf['salary_low'] = pd.to_numeric(low)
    high = ddf['salary_high'].str.replace(r'\$', '')
    high = high.str.replace(r'(,|\.\d+)', '')
    high = high.str.replace(r'K', '000')
    ddf['salary_high'] = pd.to_numeric(high)
    
    # filter salary-cols values <= 15000 | 10000
    df = ddf[ddf['salary_high'] > 15000]
    df = df[df['salary_low'] > 10000]
    
    # add new salary-average col
    df['salary_avg'] = (df['salary_low'] + df['salary_high']) / 2
    
    # convert is_remote to binary 
    remote = df['is_remote']
    df['is_remote'] = remote.apply(transform_remote)
    
    # drop job_type
    df = df.drop(['job_type'], axis=1)

    # write to csv
    df.to_csv(output_file, index=False)
    
    return

                  
if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file,output_file)