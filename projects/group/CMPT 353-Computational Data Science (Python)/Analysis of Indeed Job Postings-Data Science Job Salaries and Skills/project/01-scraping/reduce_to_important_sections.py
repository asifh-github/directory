from bs4 import BeautifulSoup
import os
import sys

def main(input_directory,output_directory):
    filenames = os.listdir(input_directory)
    for file in filenames:
        with open(input_directory + '/' + file, mode='r', encoding='utf-8') as f:
            html = f.read()
            soup = BeautifulSoup(html)
        job_title = soup.find('div',{'class':'jobsearch-JobInfoHeader-title-container'})
        salary_guide = soup.find('div',{'id':'salaryGuide'})
        job_details = soup.find('div',{'id':'jobDetailsSection'})
        job_description_title = soup.find('h2',{'id':'jobDescriptionTitle'})
        job_description = soup.find('div',{'id':'jobDescriptionText'})
        with open(f'{output_directory}/pretty-{file}',mode='w',encoding='utf-8') as f:
            # for tag in [job_title,job_details,job_description_title,job_description]
            f.write('<html>')
            f.write(str(job_title))
            f.write(str(salary_guide))
            f.write(str(job_details))
            f.write(str(job_description_title))
            f.write(str(job_description))
            f.write('</html>')


if __name__ == '__main__':
    input_directory = sys.argv[1]
    output_directory = sys.argv[2]
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    main(input_directory,output_directory)