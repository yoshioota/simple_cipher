require 'openssl'
require 'active_support'

require 'simple_cipher/version'
require 'simple_cipher/config'
require 'simple_cipher/core'

module SimpleCipher
  include SimpleCipher::Core
end
