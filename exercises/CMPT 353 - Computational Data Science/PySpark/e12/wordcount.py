import sys
assert sys.version_info >= (3, 8) # make sure we have Python 3.8+
from pyspark.sql import SparkSession, functions, types
import string, re


def main(in_directory, out_directory):
    # read file from dir as text
    text = spark.read.text(in_directory)

    # create regex to separate words from each line
    wordbreak = r'[%s\s]+' % (re.escape(string.punctuation),)
    # separate words in each line
    word_list = text.select(functions.split(text['value'], wordbreak).alias('words_per_line'))
    # convert list-of-words to rows-of-word
    words = word_list.select(functions.explode(word_list.words_per_line).alias('word'))
    
    # convert each word to lower-case
    words_lower = words.select(functions.lower(words.word).alias('word'))
    # drop empty string/rows
    words_clean = words_lower.select(functions.when(words_lower.word != '', words_lower.word).alias('word'))
    words_clean = words_clean.dropna()

    # count number of times each word appears
    words_count = words_clean.groupBy(words_clean.word).count()
    # sort count in decs order
    words_sorted = words_count.sort('count', ascending=False)
    #words_sorted.show()

    words_sorted.write.csv(out_directory, mode='overwrite')
    return


if __name__=='__main__':
    in_directory = sys.argv[1]
    out_directory = sys.argv[2]
    spark = SparkSession.builder.appName('Word Count').getOrCreate()
    assert spark.version >= '3.2' # make sure we have Spark 3.2+
    spark.sparkContext.setLogLevel('WARN')

    main(in_directory, out_directory)
