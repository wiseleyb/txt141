class Twitter

  def self.save_twitter_login(client, access_token)
    h = {}
    h[:login] = client.info["screen_name"]
    h[:token] = access_token.token
    h[:secret] = access_token.secret
    REDIS.hset "twitter-logins", h[:login], h.to_json
  end
  
  def self.get_access_token(login)
    h = REDIS.hget "twitter-logins", login
    JSON.parse(h).symbolize_keys
  rescue
    nil
  end
  
  def self.remove_twitter_login(login)
    REDIS.hdel "twitter-logins", login
  end
  
  def self.get_client(login)
    rt = Twitter.get_access_token(login)
    return nil if rt.nil?
    client = TwitterOAuth::Client.new(
        :consumer_key => TWITTER_KEY,
        :consumer_secret => TWITTER_SECRET,
        :token => rt[:token],  :secret => rt[:secret]
    )
    if client.authorized?
      return client 
    else
      nil
    end
  end
  
end

