require_relative "lib/lazy_value/version"

Gem::Specification.new do |spec|
  spec.name        = "lazy_value"
  spec.version     = LazyValue::VERSION
  spec.authors     = ["Igor Kasyanchuk", "Liubomyr Manastyretskyi"]
  spec.email       = ["igorkasyanchuk@gmail.com", "manastyretskyi@gmail.com"]
  spec.homepage    = "https://github.com/railsjazz.com/lazy_value"
  spec.summary     = "Lazy load values in Rails views."
  spec.description = "Lazy load values in Rails views."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.add_dependency "rails"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "wrapped_print"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "selenium-webdriver"
end
