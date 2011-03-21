require 'uri'

class TxtRedis

=begin
  REDIS DICTIONARY
  
  HASHES
  * code-text   finds text associated with code
  
  KEY-VALUE
  * saved       number of saved messages... should be the same as REDIS.hlen('code-text')
  * served      number of messages served
  
  SETS
  * codes       order list of keys from code-text (to allow paging)
=end

  # CHARACTERS = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a)).sort_by {rand}
  CHARACTERS = ["j", "o", "Z", "s", "G", "g", "6", "m", "z", "b", "V", "U", "D", "I", "a", "n", "M", "d", "J", "C", "w", "k", "O", "8", "v", "7", "f", "x", "A", "B", 
    "i", "T", "H", "L", "l", "R", "e", "N", "F", "Q", "2", "r", "t", "W", "3", "q", "4", "u", "y", "h", "X", "p", 
    "1", "5", "Y", "P", "9", "K", "c", "S", "E", "0"]
  
  RESERVED = %w(index twitter)
  
  def self.get_next_code(str, pos=str.size - 1)
    return CHARACTERS.first * (str.size + 1) if pos < 0 || (idx = CHARACTERS.index(str[pos,1])).nil?
    return get_next_code(str,pos - 1) if idx >= CHARACTERS.size - 1
    str[pos] = CHARACTERS[idx + 1] 
    str[pos+1..str.size-1] = CHARACTERS.first * (str.size - pos - 1) unless pos + 1 > str.size - 1
    return str
  end

  def self.generate_token
    # this needs to eventually be in a transaction
    code = ""
    loop do
      code = TxtRedis.get_next_code(REDIS.get("current_code") || "")
      break unless RESERVED.include?(code)
    end
    REDIS.set("current_code",code)
    REDIS.zadd("codes", Time.now.to_i, code)
    return code
  end

  def self.get_url(txt)
    include ActionView::Helpers::SanitizeHelper
    # TODO wrap this in a trasaction - this isn't as easy as MULTI/EXEC - probably need to use WATCH
    token = generate_token
    REDIS.hset('code-text',token,sanitize(txt))
    REDIS.incr('saved')
    return "#{BASE_URL}/#{token}"
  end

  def self.token_from_url(url)
    url.split('/').last
  end
  def self.url_from_token(token)
    return "#{BASE_URL}/#{token}"
  end
  
  def self.get_txt_for_client(txt, url, size = 140)
    if txt.size > size
      url = "... #{url}"
      len = size - url.size - 1
      "#{txt[0..len]}#{url}"
    else
      txt
    end
  end
  
  def self.get_txt(token)
    REDIS.incr('served')
    t = REDIS.hget('code-text',token)
    unless t.blank?
      t = t.gsub("\n","<br/>")
      links = URI.extract(t)
      links.uniq.each do |l|
        t.gsub!(l, "<a href='#{l}' rel='nofollow'>#{l}</a>")
      end
    end
    return t
  end

  def self.saved
    REDIS.get('saved').to_i
  end
  
  def self.served
    REDIS.get('served').to_i
  end
  
  def self.sanitize(txt)
    ActionController::Base.helpers.strip_tags(txt)
  end

  def self.set_session(session, hash_values)
    REDIS.hmset session[:session_id], *(hash_values.to_a.flatten)
    REDIS.expire session[:session_id], 60 * 10
  end

  def self.get_session(session_id)
    h = REDIS.hgetall session_id
    h.symbolize_keys
  end
  
  def self.migrate
    REDIS.hkeys("code-text").each do |code|; REDIS.zadd("codes", Time.now.to_i, code); sleep 0.01; end
  end
  
end