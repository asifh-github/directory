consumer_key = 'EPSGb6hHsZO8uapee1IHCysVu'
consumer_secret = '3dPeFP5Diyi5BZFCtYYHxvAjMddBfy8BJhIAEt67BhS3u51l1P'
access_token = '1494754817268281354-1xffiLGnh9NkN3zYGjm5Wkiubkkspz'
access_secret = 'fQZwz7fkUY7JQz4lp3MKaAaebKYqpIEaTNqpPGpwOjL0F'

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

