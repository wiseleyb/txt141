class KeyGenerator
  require "digest/sha1"
  def self.generate(length = 10)
    Digest::SHA1.hexdigest(Time.now.to_s + rand(Time.now.to_i).to_s)[1..length]
  end
end