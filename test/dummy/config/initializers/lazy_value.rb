ENV["LAZY_VALUE_KEY"] = "key"
ENV["LAZY_VALUE_SALT"] = "salt"

LazyValue.setup do |config|
  config.key  = ENV["LAZY_VALUE_KEY"]
  config.salt = ENV["LAZY_VALUE_SALT"]
end
