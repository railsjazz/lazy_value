LazyValue::Engine.routes.draw do
  get '/show' => 'application#show', as: :show
end

Rails.application.routes.draw do
  mount_routes
end
