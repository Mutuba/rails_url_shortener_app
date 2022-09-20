Rails.application.routes.draw do
  devise_for :users

  mount ActionCable.server => '/cable'
  resources :urls, only: %i[index new]

  post 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'

  root 'urls#index'
end
