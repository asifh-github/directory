from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
import time
import os
import re
import sys
import logging

def scrape_job_html(url,driver) -> str:
    '''
    Performs a job search on indeed via the selenium webdriver.
    Extracts job urls
    :param start the depth of the search to start at. Each page of the search starts 10 after the previous one. (i.e. increment by 10 to scrape next page)
    :return list of job urls
    '''
    driver.get(url)
    time.sleep(1.5)
    driver.execute_script("window.scrollTo(0, 1080)")
    time.sleep(1.5)
    html = driver.page_source
    return BeautifulSoup(html).prettify()


def main(input_directory,output_directory):
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
    filenames = os.listdir(input_directory)
    for filename in filenames:
        with open(f'{input_directory}/{filename}') as f:
            job_urls = f.readlines()
            job_urls = [url[:-1] for url in job_urls]
        for url in job_urls:
            job_key= re.search(r'jk=(.*)',url).group(1)
            html = scrape_job_html(url, driver)
            with open(f'{output_directory}/job-{job_key}.html',mode='w',encoding='utf-8') as f:
                f.write(html)

if __name__ == '__main__':
    input_directory = sys.argv[1]
    output_directory = sys.argv[2]
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    main(input_directory,output_directory)