require_relative "lib/lazy_value/version"

Gem::Specification.new do |spec|
  spec.name        = "lazy_value"
  spec.version     = LazyValue::VERSION
  spec.authors     = ["Igor Kasyanchuk"]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  spec.homepage    = "https://github.com/railsjazz.com/lazy_value"
  spec.summary     = "Summary of LazyValue."
  spec.description = "Description of LazyValue."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.add_dependency "rails"
  spec.add_dependency "parser"
  spec.add_dependency "ast"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "wrapped_print"
  spec.add_development_dependency "sprockets-rails"
end
