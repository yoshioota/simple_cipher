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
    config_accessor :iteration

    config_accessor :digest

  end

  configure do |config|
    config.cipher    = 'AES-256-CBC'
    config.iteration = 1000
    config.digest    = 'MD5'
  end
end
