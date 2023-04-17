class LazyValueGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def copy_initializer
    template 'template.rb', 'config/initializers/lazy_value.rb'
  end
end
