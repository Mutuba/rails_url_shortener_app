Rails.application.routes.draw do
  resources :urls, only: %i[index new create]
  # get 'urls/all', to: 'urls#index'
  # get 'urls/new', to: 'urls#new'
  # get 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'

  get 'about', to: 'pages#about'
  root 'pages#home'
end
