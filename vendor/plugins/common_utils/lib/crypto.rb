#performs encryption - simple wrapper around ezcrypto
require 'uri'

module Crypto

  require 'ezcrypto'

  def self.md5(data)
    Digest::MD5.hexdigest(data)
  end

  def self.encrypt(data)
    self.get_key.encrypt64 data
  end

  def self.decrypt(data)
    self.get_key.decrypt64 data
  end

  def self.get_key
    EzCrypto::Key.with_password CRYPTO_PASSWORD, CRYPTO_SALT
    #Santoka Taneda - Zen Buddhist
  end

  #use this if you want to pass this value on a parameter
  def self.encrypt_uri_encoded(data)
    uri_escape(encrypt(data))
  end

  #use this value if it's been URI encoded
  def self.decrypt_encoded(data)
    decrypt(uri_unescape(data))
  end

  def self.uri_escape(value)
    URI.escape(value, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def self.uri_unescape(value)
    URI.unescape(value)
  end

  # def self.generate_salt( len )
  #     chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  #     newpass = ""
  #     1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
  #     return newpass
  # end

end