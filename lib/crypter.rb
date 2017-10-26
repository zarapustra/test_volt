module Crypter
  def encrypt(pt)
    encryptor.encrypt_and_sign pt
  end

  def decrypt(ct)
    encryptor.decrypt_and_verify ct
  end

  def valid_password(enc_pass, pass)
  end
  private

  def encryptor
    @_encryptor ||= ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
  end
end
