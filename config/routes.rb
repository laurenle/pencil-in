# config/routes.rb
PencilIn::Application.routes.draw do
  get 'calendars/create'

  get 'calendars/new'

  resources :sessions, :users, :tasks

  post '/tasks/confirm', to: 'tasks#confirm'

  root to: 'welcome#index'
  get "/auth/:provider/callback" => 'calendars#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

end
