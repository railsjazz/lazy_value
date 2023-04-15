module LazyValue
  class Engine < ::Rails::Engine
    isolate_namespace LazyValue

    config.to_prepare do
      ActiveSupport.on_load(:action_view) do
        include LazyValue::ApplicationHelper
      end
    end
  end
end
