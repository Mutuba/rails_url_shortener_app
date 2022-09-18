Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users

  resources :urls, only: %i[index new]

  post 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'

  root 'urls#index'
end
