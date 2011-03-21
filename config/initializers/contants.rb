case Rails.env
when "development"
  REDIS = Redis.new(:port => 6390)
  BASE_URL = "http://localhost:3000"
when "test"
  REDIS = Redis.new(:port => 6391)
  BASE_URL = "http://localhost:3000"
when "production"
  REDIS = Redis.new(:port => 6392)
  BASE_URL = "http://txt141.com"
end
# 

TWITTER_KEY = 'KxYG2vJrMiROA0bemkv4bA'
TWITTER_SECRET = '1foqyOiwf2npphraQUGycxwVuGNuck8s3jb11NL0'


=begin
twitter credentials

consumer key
KxYG2vJrMiROA0bemkv4bA

consumer secret
1foqyOiwf2npphraQUGycxwVuGNuck8s3jb11NL0

request token url
http://twitter.com/oauth/request_token

access token url
http://twitter.com/oauth/access_token

authorize url
http://twitter.com/oauth/authorize

=end