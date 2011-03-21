class TwitterController < ApplicationController
  
  layout 'application'
  
  # https://github.com/moomerman/twitter_oauth
  
  def create
    unless session[:login].blank?
      url = tweet(session[:session_id])
      unless url.nil?
        redirect_to url and return
      end
    end
    if ::Rails.env == "production"
      client = TwitterOAuth::Client.new(
          :consumer_key => TWITTER_KEY,
          :consumer_secret => TWITTER_SECRET
      )
      request_token = client.request_token(:oauth_callback => "#{BASE_URL}/twitter/tweetback?sid=#{session[:session_id]}")
      session[:request_token] = {:token => request_token.token, :secret => request_token.secret}
      redirect_to request_token.authorize_url
    else
      session[:login] = ::Rails.env
      url = tweet(session[:session_id])
      if url.nil?
        redirect_to "/" and return
      else
        redirect_to url and return
      end
    end
  end
  

# oauth_token=TvkBoMx2PPU4E44mYDQol5PB4pbeEr79yc9kKQnwOk8&oauth_verifier=G38kFjNJYFjIZKm75k9Ti8JJUtdF9y3lQqj8krXEtk
    
  # def login
  #   client = TwitterOAuth::Client.new(
  #       :consumer_key => TWITTER_KEY,
  #       :consumer_secret => TWITTER_SECRET
  #   )
  #   request_token = client.request_token(:oauth_callback => "#{BASE_URL}/twitter/tweetback")
  #   session[:request_token] = {:token => request_token.token, :secret => request_token.secret}
  #   redirect_to request_token.authorize_url
  # end
  def tweetback
    if params[:oauth_verifier]
      rt = session[:request_token]
      client = TwitterOAuth::Client.new(
          :consumer_key => TWITTER_KEY,
          :consumer_secret => TWITTER_SECRET
      )
      access_token = client.authorize(
        rt[:token],
        rt[:secret],
        :oauth_verifier => params[:oauth_verifier]
      )
      if client.authorized?
        Twitter.save_twitter_login(client,access_token)
        session[:login] = client.info["screen_name"]
        url = tweet(params[:sid])
        unless url.nil?
          redirect_to url and return
        end
        flash[:alert] = "URL was nil"
      else
        flash[:alert] = "Unauthorized"
      end
    end
    redirect_to "/"
    #redirect_to "/twitter/tweet"
  end

  def logout
    key = session[:login]
    Twitter.remove_twitter_login(key)
    REDIS.del session[:session_id]
    session[:login] = nil
    redirect_to "/"
  end
  
  def tweet(sid = session[:session_id])
    if ::Rails.env == "production"
      client = Twitter.get_client(session[:login])
      if client.authorized?
        txtr = TxtRedis.get_session(sid)
        if txtr == {} || txtr[:txt].blank?
          # raise "a1"
          flash[:alert] = "We couldn't find that record"
          return "/" 
        else
          # raise "a2"
          client.update(txtr[:txt]) 
          flash[:notice] = "Tweet sent by #{session[:login]}: #{txtr[:txt]}"
          REDIS.del sid
          return txtr[:url] 
        end
      else
        flash[:alert] = "Problems authorizing account"
        return "/"
      end
    else
      txtr = TxtRedis.get_session(sid)
      if txtr == {} || txtr[:txt].blank?
        # raise "a3"
        flash[:alert] = "We couldn't find that record (#{::Rails.env})"
        return "/" 
      else
        # raise "a4"
        flash[:notice] = "Tweet sent by #{session[:login]}:  #{txtr[:txt]} (#{::Rails.env})"
        REDIS.del sid
        return txtr[:url] 
      end
    end
    h = {:env => ::Rails.env, :session => session[:login], :session_id => session[:session_id], :txtr => TxtRedis.get_session(session).to_yaml}
    flash[:alert] = "#{h.to_yaml}"
    return nil
  rescue 
    flash[:alert] = "Error: #{$!.message}"
    return nil
  end
  
end