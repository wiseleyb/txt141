case Rails.env
when "development"
  ENV["REDISTOGO_URL"] = 'redis://127.0.0.1:6390' 
  BASE_URL = "http://localhost:3000"
when "test"
  ENV["REDISTOGO_URL"] = 'redis://127.0.0.1:6391' 
  BASE_URL = "http://localhost:3000"
when "production"
  BASE_URL = "http://txt141.heroku.com"
end


uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

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