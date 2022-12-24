import sys
import pandas as pd
from dataclasses import dataclass
import re

@dataclass
class Role:
    title : str
    pattern : str

@dataclass
class Seniority:
    level : str
    pattern : str

#in the job titles these roles are all preceeded by 'data' so we omit 'data' from their names
#for brevity
ROLE_LIST = [
    Role('analyst',r'analy'),
    Role('engineer',r'ml|engineer'),
    Role('scientist',r'scien'),
    # Role('researcher',r'research'),
    # Role('labeler',r'label|visual') #for anova we will only look at these three
]

SENIORITY_LIST = [
    Seniority('assisstant',r'assist'),
    Seniority('jr',r'jr|juni|associa'),
    Seniority('sr',r'sr|seni'),
]


def assign_role(title : str) -> str:
    '''
    Parses a job_title and assigns it a role. To be used in call to apply on 
    series containing job titles
    '''
    for role in ROLE_LIST:
        if re.search(role.pattern,title,re.IGNORECASE):
            return role.title
    return 'unknown'

def assign_seniority(title : str) -> str:
    '''
    Parses a job_title and extracts the seniority. To be used in a call
    to apply on a series containing job titles
    '''
    for seniority in SENIORITY_LIST:
        if re.search(seniority.pattern,title,re.IGNORECASE):
            return seniority.level
    return 'unknown'

#https://pandas.pydata.org/docs/reference/api/pandas.get_dummies.html

def clean_titles(df):
    df = df.copy()
    df['role'] = df.job_title.apply(assign_role)
    df['seniority'] = df.job_title.apply(assign_seniority)
    return df

def main(input_file,output_file):
    df = pd.read_csv(input_file)
    df['role'] = df.job_title.apply(assign_role)
    df['seniority'] = df.job_title.apply(assign_seniority)
    df.to_csv(output_file)

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file,output_file)