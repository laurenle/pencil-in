# config/routes.rb
PencilIn::Application.routes.draw do
  get 'calendars/create'
  get 'calendars/new'

  resources :sessions, :users, :calendars, :tasks

  post '/tasks/:id/users', to: 'tasks#add_users_task', as: 'add_users_task'
  get '/tasks', to: 'tasks#index'

  root to: 'welcome#index'
  get "/auth/:provider/callback" => 'calendars#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
