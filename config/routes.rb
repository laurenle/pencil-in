# config/routes.rb
PencilIn::Application.routes.draw do
  resources :lists

  root to: 'welcome#index'
  resources :sessions
  get "/auth/:provider/callback" => 'sessions#create'
end
