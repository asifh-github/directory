from clean_salaries import clean_salaries
from title_cleaning import clean_titles
import pandas as pd
import sys

def main(input_file,output_file):
    df = pd.read_csv(input_file)
    df = clean_salaries(df)
    df = clean_titles(df)
    df.to_csv(output_file, index=False)

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file,output_file)
