# config/routes.rb
PencilIn::Application.routes.draw do
  resources :tasks

  get 'authorize/create'

  get 'authorize/new'

  resources :lists, :users

  root to: 'welcome#index'
  resources :sessions
  get "/auth/:provider/callback" => 'authorize#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  post '/tasks/confirm', to: 'tasks#confirm'

end
