Rails.application.routes.draw do
  root to: "home#index"
  get "/lazy" => "home#lazy"
end
