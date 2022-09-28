require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  devise_for :users
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
  mount ActionCable.server => '/cable'
  resources :urls, only: %i[new index]

  post 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'
  get 'batch/stats', to: 'batch_metrics#batch_stats'
  get 'batch/upload_status', to: 'batch_metrics#upload_status'
  get 'batch_urls', to: 'batch_metrics#batch_urls'
  post 'batch_urls', to: 'batch_metrics#batch_urls'

  root 'urls#index'
end
