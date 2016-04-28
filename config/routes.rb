Rails.application.routes.draw do
  resources :users

  resources :lists

  get 'list/new'

  get 'list/order'

end

# config/routes.rb
PencilIn::Application.routes.draw do
  resources :users

  resources :lists

  get 'list/new'

  get 'list/order'

  root to: 'welcome#index'
  resources :sessions
  get "/auth/:provider/callback" => 'sessions#create'
end
