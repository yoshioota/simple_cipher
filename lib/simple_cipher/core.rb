module SimpleCipher
  module Core
    extend ActiveSupport::Concern

    module ClassMethods

      def encrypt(data)
        cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher)
        cipher.encrypt

        cipher.key, cipher.iv = get_key_and_iv(cipher)

        cipher.update(data) + cipher.final
      end
      alias_method :e, :encrypt

      def decrypt(data)
        cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher)
        cipher.decrypt

        cipher.key, cipher.iv = get_key_and_iv(cipher)

        cipher.update(data) + cipher.final
      end
      alias_method :d, :decrypt

      def get_key_and_iv(cipher)
        @cached_key_iv_digest ||= nil

        if @cached_key_iv_digest != make_cache(ciper)
          @cached_key_iv = OpenSSL::PKCS5.pbkdf2_hmac(
              SimpleCipher.config.password,
              SimpleCipher.config.salt,
              SimpleCipher.config.iteration,
              cipher.key_len + cipher.iv_len,
              SimpleCipher.config.digest)
        end

        [@key_iv[0, cipher.key_len], @key_iv[cipher.key_len, cipher.iv_len]]
      end

      def make_cache(cipher)
        "#{SimpleCipher.config.password}:#{SimpleCipher.config.salt}:#{SimpleCipher.config.iteration}:#{cipher.key_len}:#{cipher.iv_len}:#{SimpleCipher.config.digest}"
      end
    end
  end
end
