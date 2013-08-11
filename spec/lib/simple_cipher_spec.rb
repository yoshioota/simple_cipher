# coding: utf-8

require 'spec_helper'

describe SimpleCipher do

  let(:password_1) { SecureRandom.hex(8) }
  let(:salt_1) { SecureRandom.hex(4) }

  let(:password_2) { SecureRandom.hex(8) }
  let(:salt_2) { SecureRandom.hex(4) }

  def set_config(num = 1)
    SimpleCipher.configure do |config|
      config.password = send(:"password_#{num}")
      config.salt     = send(:"salt_#{num}")
    end
  end

  it do
    set_config(1)

    plain_text     = 'hello world!'
    encrypted_text = SimpleCipher.encrypt(plain_text)
    plain_text.should_not == encrypted_text
    plain_text.should == SimpleCipher.decrypt(encrypted_text)

    set_config(2)
    expect { SimpleCipher.decrypt(encrypted_text) }.to raise_error

    plain_text.should_not == SimpleCipher.encrypt('hello world?')
  end

  it 'caching key_iv' do
    set_config(1)
    cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher).encrypt
    key_iv_1 = SimpleCipher.update_key_iv(cipher)

    set_config(1)
    key_iv_2 = SimpleCipher.update_key_iv(cipher)
    key_iv_1.object_id.should == key_iv_2.object_id
  end

  it 'change key_iv' do
    set_config(1)
    cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher).encrypt
    key_iv_1 = SimpleCipher.update_key_iv(cipher)

    set_config(2)
    cipher = OpenSSL::Cipher.new(SimpleCipher.config.cipher).encrypt
    key_iv_2 = SimpleCipher.update_key_iv(cipher)
    key_iv_1.should_not == key_iv_2
  end
end
