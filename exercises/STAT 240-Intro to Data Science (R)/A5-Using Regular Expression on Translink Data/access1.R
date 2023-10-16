consumer_key = 'xxxxx'
consumer_secret = 'xxxxx'
access_token = 'xxxxx'
access_secret = 'xxxxx'

setup_twitter_oauth(
  consumer_key,
  consumer_secret,
  access_token,
  access_secret
)

rm(
  c(
  'consumer_key',
  'consumer_secret',
  'access_token',
  'access_secret'
  )
)

