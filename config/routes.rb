Rails.application.routes.draw do
  devise_for :users
  resources :urls, only: %i[index new create]
  # get 'urls/all', to: 'urls#index'
  # get 'urls/new', to: 'urls#new'
  # get 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'

  root 'urls#index'
end
