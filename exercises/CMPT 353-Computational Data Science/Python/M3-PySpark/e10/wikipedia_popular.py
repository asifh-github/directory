import sys
import re
from pyspark.sql import SparkSession, functions, types, DataFrameReader

spark = SparkSession.builder.appName('reddit averages').getOrCreate()
spark.sparkContext.setLogLevel('WARN')

assert sys.version_info >= (3, 8) # make sure we have Python 3.8+
assert spark.version >= '3.2' # make sure we have Spark 3.2+


wiki_schema = types.StructType([
    types.StructField('language', types.StringType()),
    types.StructField('page', types.StringType()),
    types.StructField('count', types.IntegerType()),
    types.StructField('size', types.LongType()),
])

def filename_to_date(filename):
    date = re.search('\\d{8}-\\d{2}', filename)[0]
    return date
    
def main(in_directory, out_directory):
    # create user-defined-functions (udf)
    path_to_hour = functions.udf(filename_to_date, returnType=types.StringType())
    # read csv_dir with filename
    wiki_pages = spark.read.csv(in_directory, schema=wiki_schema, sep=' ') \
                 .withColumn('filename', path_to_hour(functions.input_file_name()))
    #wiki_pages.show()

    # keep the cols we care about
    # (1) English Wikipedia pages (i.e. language is "en") only
    pages_filtered = wiki_pages.filter(wiki_pages['language'] == 'en')
    # (2) The most frequent page is usually the front page (title is 'Main_Page') but that's boring, so exclude it
    # (3) Also, “special” (titles starting with 'Special:') are boring and should also be excluded 
    pages_filtered = pages_filtered.filter(~(pages_filtered['page'] == 'Main_Page') & ~(pages_filtered['page'].startswith('Special:')))
    pages_filtered.cache()
    #pages_filtered.show()
    
    # find the largest number of page views in each hour
    # ... then join that back to the collection of all page counts, so you keep only those with the count == max(count) for that hour
    max_views_by_hour = pages_filtered.groupBy('filename').max('count')
    max_views_by_hour = max_views_by_hour.select(max_views_by_hour['filename'].alias('path'), max_views_by_hour['max(count)'])
    #max_views_by_hour.show()
    pop_pages = max_views_by_hour.join(pages_filtered, max_views_by_hour['max(count)'] == pages_filtered['count'], 'inner')
    pop_pages = pop_pages.filter(pop_pages['path'] == pop_pages['filename'])
    #pop_pages.show()
    # revome unnecessary cols
    popular_cleaned = pop_pages.drop('path', 'max(count)', 'language', 'size')
    #popular_cleaned.show()
    
    # sort your results by date/hour (and page name if there's a tie)
    # ... and output as a CSV
    popular_sorted = popular_cleaned.sort('filename', 'page')
    popular_sorted = popular_sorted.select('filename', 'page', 'count')
    #popular_sorted.show()
    #popular_sorted.explain()
    
    popular_sorted.write.csv(out_directory, mode='overwrite')       # not using compression 
    return


if __name__=='__main__':
    in_directory = sys.argv[1]
    out_directory = sys.argv[2]
    main(in_directory, out_directory)
