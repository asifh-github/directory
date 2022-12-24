import pandas as pd
import sys
import os
import re
from wordcloud import STOPWORDS




def main(job_file,skill_file,ouput_file):
    job_df = pd.read_csv(job_file)
    skill_df = pd.read_csv(skill_file)
    job_df['job_key'] = job_df.job_key.str.replace('job-','')
    job_df = job_df.set_index('job_key')
    skill_df = skill_df.set_index('job_key')
    df = job_df.join(skill_df)
    
    for word in ['data','data science','Experience','Computer','Ability','work','strong','science','qualifications','responsibilities','job']:
        STOPWORDS.add(word.lower())
    STOPWORDS.remove('r')

    #filter out stop words

    df = df[['role','seniority','is_intern','skill']]
    df = df.loc[~df.skill.str.lower().isin(STOPWORDS)].dropna()
    df.to_csv(output_file)
    
    
    




        

if __name__ == '__main__':
    job_file = sys.argv[1]
    skill_file = sys.argv[2]
    output_file = sys.argv[3]
    main(job_file,skill_file,output_file)