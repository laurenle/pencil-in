# config/routes.rb
PencilIn::Application.routes.draw do
  get 'calendars/create'
  get 'calendars/new'

  resources :sessions, :users, :calendars, :tasks

  get '/tasks', to: 'tasks#index'

  root to: 'welcome#index'
  get "/auth/:provider/callback" => 'calendars#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
