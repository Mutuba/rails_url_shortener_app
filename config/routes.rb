Rails.application.routes.draw do
  devise_for :users
  resources :urls, only: %i[index new create]
  get 'urls/show', to: 'urls#show'

  root 'urls#index'
end
