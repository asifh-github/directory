The code in this directory was used to scape the job postings. If you wish to run it you will need the following python packages installed (pip works).

bs4
selenium
webriver_manager
pandas

The rest of the libraries should be in the python standard library, but I make no guarantees.

The scraping can be performed as follows:

Open a terminal and navigate to this directory, then run:

python get_job_urls.py [output-directory] [location] [job-query] [n-pages]

This will visit the search page of indeed with location and query arguments. It will scrape the urls linking to the job postings returned by the search.

[location] is the geographic location of the jobs you are looking for. We are visiting the american website so locations should be american states cities or simply USA for a global search

[job-query] should be a string of search terms separated by '+' e.g. "data+scientist"

[n-pages] will

python 01-scraping/scrape_job_postings_html.py 01-scraping/usa/additional-urls 01-scraping/usa/job-html

python 01-scraping/reduce_to_important_sections.py 01-scraping/usa/job-html 01-scraping/usa/pretty-job-html

python 02-extraction/extract_to_csv.py 01-scraping/for-extraction 02-extraction/for-cleaning/extracted-data.csv

python 03-cleaning/anova_preprocessing.py 02-extraction/for-cleaning/extracted-data.csv 03-cleaning/for-anova/anova-data.csv

python 03-cleaning/feature_extraction.py 02-extraction/for-cleaning/extracted-data.csv 03-cleaning/for-regression/regression-data.csv