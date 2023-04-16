LazyValue::Engine.routes.draw do
  get '/show' => 'application#show', as: :show
end

Rails.application.routes.draw do
  mount_lazy_value_routes
end
