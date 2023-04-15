module ActionDispatch::Routing
  class Mapper
    def mount_routes(options = {})
      mount LazyValue::Engine => '/lazy_value', :as => options[:as] || 'lazy_value'
    end
  end
end
