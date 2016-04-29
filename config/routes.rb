# config/routes.rb
PencilIn::Application.routes.draw do
  resources :tasks

  get 'authorize/create'

  get 'authorize/new'

  resources :sessions, :lists, :users, :tasks

  post '/tasks/confirm', to: 'tasks#confirm'

  root to: 'welcome#index'
  get "/auth/:provider/callback" => 'authorize#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

end
