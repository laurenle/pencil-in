Rails.application.routes.draw do
end

# config/routes.rb
PencilIn::Application.routes.draw do
  root to: 'welcome#index'
  resources :sessions, only: :index
  get "/auth/:provider/callback" => 'sessions#create'
end
