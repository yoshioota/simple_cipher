require 'active_support/concern'

module SimpleCipher
  module Core
    extend ActiveSupport::Concern

    module ClassMethods

      def encrypt(plain_text)
        cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher).encrypt
        set_key_and_iv(cipher)
        encrypted_text = cipher.update(plain_text) + cipher.final
        encrypted_text.unpack('H*').first
      end

      def decrypt(encrypted_text)
        cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher).decrypt
        set_key_and_iv(cipher)
        packed_text = [encrypted_text].pack('H*')
        cipher.update(packed_text) + cipher.final
      end

      alias_method :e, :encrypt
      alias_method :d, :decrypt

      def set_key_and_iv(cipher)
        update_key_iv(cipher)

        cipher.key = @cached_key_iv[0, cipher.key_len]
        cipher.iv  = @cached_key_iv[cipher.key_len, cipher.iv_len]
      end

      def update_key_iv(cipher)
        @cached_key_iv_identifier ||= nil
        if ! key_iv_cache_exist?(cipher)
          @cached_key_iv            = create_key_iv(cipher)
          @cached_key_iv_identifier = key_iv_identifier(cipher)
        end
        @cached_key_iv
      end

      def key_iv_cache_exist?(cipher)
        @cached_key_iv_identifier == key_iv_identifier(cipher)
      end

      def key_iv_identifier(cipher)
        "#{SimpleCipher.config.password}:#{SimpleCipher.config.salt}:#{SimpleCipher.config.iteration}:#{cipher.key_len}:#{cipher.iv_len}:#{SimpleCipher.config.digest}"
      end

      def create_key_iv(cipher)
        OpenSSL::PKCS5.pbkdf2_hmac(
            SimpleCipher.config.password,
            SimpleCipher.config.salt,
            SimpleCipher.config.iteration,
            cipher.key_len + cipher.iv_len,
            SimpleCipher.config.digest)
      end
    end
  end
end
