from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
import time
import os
import re
import sys
from typing import List

OUTPUT_DIRECTORY = sys.argv[1]
LOCATION = sys.argv[2]
JOB_QUERY = sys.argv[3] #separate search words with '+'
RUNS = int(sys.argv[4])

INDEED_URL = "https://www.indeed.com/"
VIEW_JOB_ENDPOINT = 'viewjob?jk='


OUTPUT_FILE = 'job-urls-{n}.txt'




def get_job_urls_from_html(html : str) -> List[str]:
    '''
    :param html: html of a job search on indeed.
    :return: list of urls to the job postings in the search
    '''
    #some of the links send you out of indeed but if you extract the job key and append it to VIEW_JOB_ENDPOINT
    #it stays on indeed
    soup = BeautifulSoup(html)
    a_tags = soup.find_all('a')
    job_tags = [tag for tag in a_tags if "href" in tag.attrs and '/rc/clk?' in tag["href"]]
    job_keys = [re.search(r'jk=(.*?)&',str(tag['href'])).group(1) for tag in job_tags]

    job_urls = [INDEED_URL + VIEW_JOB_ENDPOINT + jk for jk in job_keys]
    return job_urls

def scrape_urls_from_starting_point(start : int,driver) -> List[str]:
    '''
    Performs a job search on indeed via the selenium webdriver.
    Extracts job urls
    :param start the depth of the search to start at. Each page of the search starts 10 after the previous one. (i.e. increment by 10 to scrape next page)
    :return list of job urls
    '''
    url = ("https://www.indeed.com/"
        "jobs?"
        f"q={JOB_QUERY}"
        f"&l={LOCATION}"
        f"&start={start}")
    driver.get(url)
    time.sleep(3)
    driver.execute_script("window.scrollTo(0, 1080)")
    time.sleep(2)
    html = driver.page_source
    return get_job_urls_from_html(html)


def main():
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
    for i in range(RUNS):
        job_urls = scrape_urls_from_starting_point(start=i*10,driver=driver)
        with open(OUTPUT_DIRECTORY +'/' + OUTPUT_FILE.format(n=i),mode='w') as f:
            for url in job_urls:
                f.write(url + '\n')

if __name__ == '__main__':
    if not os.path.exists(OUTPUT_DIRECTORY):
        os.makedirs(OUTPUT_DIRECTORY)
    main()