SimpleCipher.configure do |config|
  config.password  = nil
  config.salt      = nil
  config.cipher    = 'AES-256-CBC'
  config.digest    = 'MD5'
  config.iteration = 1000
end
