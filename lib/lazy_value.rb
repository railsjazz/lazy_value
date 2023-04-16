require "lazy_value/version"
require "lazy_value/routes"
require "lazy_value/engine"

module LazyValue
  mattr_accessor :cryptography

  @@cryptography = begin
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.random_bytes(len)
    key   = ActiveSupport::KeyGenerator.new(SecureRandom.hex(32)).generate_key(salt, len)
    ActiveSupport::MessageEncryptor.new(key)
  end

end
