require "lazy_value/version"
require "lazy_value/routes"
require "lazy_value/engine"

module LazyValue
  mattr_accessor :key
  @@key = ENV["LAZY_VALUE_KEY"].presence || SecureRandom.hex(32)

  mattr_accessor :salt
  @@salt = ENV["LAZY_VALUE_SALT"].presence || SecureRandom.hex(8)

  def self.setup
    yield(self)
  end

  def self.cryptography
    @cryptography ||= begin
      ActiveSupport::MessageEncryptor.new(derived_key)
    end
  end

  def self.derived_key
    key_generator.generate_key(salt, 32)
  end

  def self.key_generator
    ActiveSupport::KeyGenerator.new(key, iterations: 1000)
  end

end
