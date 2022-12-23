import sys
from pyspark.sql import SparkSession, functions, types

spark = SparkSession.builder.appName('weather ETL').getOrCreate()
spark.sparkContext.setLogLevel('WARN')

assert sys.version_info >= (3, 8) # make sure we have Python 3.8+
assert spark.version >= '3.2' # make sure we have Spark 3.2+

observation_schema = types.StructType([
    types.StructField('station', types.StringType()),
    types.StructField('date', types.StringType()),
    types.StructField('observation', types.StringType()),
    types.StructField('value', types.IntegerType()),
    types.StructField('mflag', types.StringType()),
    types.StructField('qflag', types.StringType()),
    types.StructField('sflag', types.StringType()),
    types.StructField('obstime', types.StringType()),
])


def main(in_directory, out_directory):
    
    # Read the input directory of .csv.gz files.
    weather = spark.read.csv(in_directory, schema=observation_schema)
    #weather.show(); return

    # TODO: finish here.
    # Keep only the records we care about:
    # qflag (quality flag) is null
    # station starts with 'CA'
    # observation is 'TMAX'
    filtered = weather.filter(weather['qflag'].isNull())
    filtered = filtered.filter(filtered['station'].startswith('CA'))
    filtered = filtered.filter(filtered['observation'] == 'TMAX')
    #filtered.show(); return
    
    # Divide the temperature by 10 so it's actually in °C, and call the resulting column tmax.
    # Keep only the columns station, date, and tmax.
    cleaned_data = filtered.select(
        filtered['station'],
        filtered['date'],
        (filtered['value'] / 10).alias('tmax'), 
    )
    #cleaned_data.show(); return
    
    # Write the result as a directory of JSON files GZIP compressed (in the Spark one-JSON-object-per-line way).
    cleaned_data.write.json(out_directory, compression='gzip', mode='overwrite')


if __name__=='__main__':
    in_directory = sys.argv[1]
    out_directory = sys.argv[2]
    main(in_directory, out_directory)
