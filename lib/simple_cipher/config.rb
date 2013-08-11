require 'active_support/configurable'

module SimpleCipher

  def self.configure(&block)
    yield @config ||= SimpleCipher::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable

    config_accessor :password
    config_accessor :salt
    config_accessor :cipher
    config_accessor :digest
    config_accessor :iteration
  end
end

unless SimpleCipher.config

  # default values
  # copy to generators/simple_cipher_config.rb

  SimpleCipher.configure do |config|
    config.password  = nil
    config.salt      = nil
    config.cipher    = 'AES-256-CBC'
    config.digest    = 'MD5'
    config.iteration = 1000
  end
end
