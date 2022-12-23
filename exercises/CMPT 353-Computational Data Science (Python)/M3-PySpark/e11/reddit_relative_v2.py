import sys
assert sys.version_info >= (3, 8) # make sure we have Python 3.8+
from pyspark.sql import SparkSession, functions, types

comments_schema = types.StructType([
    types.StructField('archived', types.BooleanType()),
    types.StructField('author', types.StringType()),
    types.StructField('author_flair_css_class', types.StringType()),
    types.StructField('author_flair_text', types.StringType()),
    types.StructField('body', types.StringType()),
    types.StructField('controversiality', types.LongType()),
    types.StructField('created_utc', types.StringType()),
    types.StructField('distinguished', types.StringType()),
    types.StructField('downs', types.LongType()),
    types.StructField('edited', types.StringType()),
    types.StructField('gilded', types.LongType()),
    types.StructField('id', types.StringType()),
    types.StructField('link_id', types.StringType()),
    types.StructField('name', types.StringType()),
    types.StructField('parent_id', types.StringType()),
    types.StructField('retrieved_on', types.LongType()),
    types.StructField('score', types.LongType()),
    types.StructField('score_hidden', types.BooleanType()),
    types.StructField('subreddit', types.StringType()),
    types.StructField('subreddit_id', types.StringType()),
    types.StructField('ups', types.LongType()),
    #types.StructField('year', types.IntegerType()),
    #types.StructField('month', types.IntegerType()),
])


def main(in_directory, out_directory):
    comments = spark.read.json(in_directory, schema=comments_schema)
    # cache!
    comments = comments.cache()

    # TODO: Determine the author of the “best” comment in each subreddit
    # 1. calculate the average score for each subreddit
    comm_select = comments.select(
        comments['subreddit'], 
        comments['score'],
    )
    
    groups = comm_select.groupBy(comm_select['subreddit'])
    averages = groups.agg(functions.avg(comm_select['score']))
    # 2. Exclude any subreddits with average score ≤0.
    averages = averages.filter(averages['avg(score)'] > 0)
    # cache!
    averages = averages.cache()
    # 3. Join the average score to the collection of all comments. Divide to get the relative score.
    joined_df = comments.join(averages.hint('broadcast'), 'subreddit', 'inner')
    rel_score = joined_df.select(
        joined_df['subreddit'],
        joined_df['author'],
        (joined_df['score'] / joined_df['avg(score)']).alias('relative_score'),
        )
    # cache!
    rel_score.cache()
    # 4. Determine the max relative score for each subreddit.
    rel_score_max = rel_score.groupBy(rel_score['subreddit']).max('relative_score')
    # cache!
    rel_score_max.cache()
    # 5. Join again to get the best comment on each subreddit: we need this step to get the author.
    author_df = rel_score.join(rel_score_max.hint('broadcast'), 'subreddit', 'inner')
    author_df = author_df.filter(author_df['relative_score'] == author_df['max(relative_score)']) \
                .drop(author_df['max(relative_score)'])
    #author_df.show()
   
    author_df.write.json(out_directory, mode='overwrite')
    return 

if __name__=='__main__':
    in_directory = sys.argv[1]
    out_directory = sys.argv[2]
    spark = SparkSession.builder.appName('Reddit Relative Scores').getOrCreate()
    assert spark.version >= '3.2' # make sure we have Spark 3.2+
    spark.sparkContext.setLogLevel('WARN')

    main(in_directory, out_directory)
