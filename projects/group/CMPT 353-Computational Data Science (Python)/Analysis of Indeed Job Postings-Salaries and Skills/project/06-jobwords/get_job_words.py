
from bs4 import BeautifulSoup
import pandas as pd
import sys
import os
import re


def main(input_directory,ouput_file):
    #get descriptions
    descriptions = []
    for filename in os.listdir(input_directory):
        with open(input_directory + '/' + filename,encoding='utf-8') as f:
            soup = BeautifulSoup(f.read())
        description = soup.find('div',{'id':'jobDescriptionText'}).text
        jobkey = re.search(r'job-(.*).html',filename).group(1)
        descriptions.append( [jobkey,description])
    # make df
    df = pd.DataFrame(columns = ['job_key','description'], data = descriptions)
    df = df.set_index('job_key')

    # find skills
    # we are only considering words that start with an uppercase letter
    # we are considering skills that are a combination of up to 3 of these words
    one_word_skills = df.description.str.findall(r'\b[A-Z][a-zA-Z]*?\b').explode()
    two_word_skills = df.description.str.findall(r'\b[A-Z][a-zA-Z]*?(?: |-)[A-Z][a-zA-Z]*?\b').explode()
    three_word_skills = df.description.str.findall(r'\b[A-Z][a-zA-Z]*?(?: |-)[A-Z][a-zA-Z]*?\b(?: |-)[A-Z][a-zA-Z]*?\b').explode()
    skills = pd.concat([one_word_skills,two_word_skills,three_word_skills]).rename('skill')
    skills_df = pd.DataFrame(skills).reset_index().drop_duplicates(subset=['job_key','skill']).dropna()

    #write to csv
    skills_df.to_csv(ouput_file,index=False)
    
    




        

if __name__ == '__main__':
    input_directory = sys.argv[1]
    output_file = sys.argv[2]
    main(input_directory,output_file)
