import os
import re
import sys
import pandas as pd
from bs4 import BeautifulSoup


def main(input_directory,output_file):
    df = pd.DataFrame(columns=['job_key', 'job_title', 'salary_low', 'salary_high', 'is_remote', 'job_type', 'is_intern'])
    
    filenames = os.listdir(input_directory)
    for filename in filenames:
        with open(f'{input_directory}/{filename}',encoding='utf-8') as f:
            post = f.read()
            soup = BeautifulSoup(post)
            # job-title
            job_title = soup.h1.text.strip()
            # job-type
            type_tag = soup.find_all("div", class_="jobsearch-JobDescriptionSection-section")
            # job-salary-str
            job_salary = ''
            upper = lower = '0'
            # remote-str
            is_remote = ''
            # type-str
            is_intern = 0
            job_type = '' 
            for section in type_tag:
                # job-salary
                if job_salary == '':
                    salary = re.findall(r'\$\d+,?.?\d+K?', section.text)
                    if salary:
                        if len(salary) == 1:
                            upper = salary[0]
                            lower = salary[0]
                        else:
                            upper = salary[1]
                            lower = salary[0]
                # remote job-type 
                if is_remote == '':
                    remote = re.findall(r'remote', section.text, re.IGNORECASE)
                    if(remote):
                        is_remote = 'Y'

                #  job-type 
                if job_type == '':
                    typ = re.findall(r'full-?time', section.text, re.IGNORECASE)
                    if(typ):
                        job_type = 'Full-time'
                    else:
                        typ = re.findall(r'contract', section.text, re.IGNORECASE)
                        if(typ):
                            job_type = 'Contract'
                        else:
                            typ = re.findall(r'intern', section.text, re.IGNORECASE)
                            if(typ):
                                job_type = 'Internship'
                            else:
                                typ = re.findall(r'part-?time', section.text, re.IGNORECASE)
                                if(typ):
                                    job_type = 'Part-time'
                    
                #is internship or coop, 0-no or 1-yes
                if is_intern == 0:
                    for keyword in [r'co-?op',r'intern([^a]|$)']:
                        if  re.search(keyword,section.text,re.IGNORECASE):
                            is_intern = 1
                            break


            if (job_title):
                fname = re.findall(r'job-\w+', filename)[0]
                if is_remote == '':
                    is_remote = 'N'
                if job_type == '':
                    job_type = 'Full-time (i)'
                if is_intern == 0:
                    for keyword in [r'co-?op',r'intern([^a]|$)']:
                        if  re.search(keyword,job_title,re.IGNORECASE):
                            is_intern = 1
                            break

                df = df.append({'job_key':fname, 'job_title':job_title, \
                                'salary_low':lower, 'salary_high':upper, \
                                'is_remote':is_remote, 'job_type':job_type, 'is_intern':is_intern}, \
                               ignore_index=True)
            
            # write to csv
            df.to_csv(output_file, index=False)
            
            
if __name__ == '__main__':
    input_directory = sys.argv[1]
    output_file = sys.argv[2]
    main(input_directory,output_file)