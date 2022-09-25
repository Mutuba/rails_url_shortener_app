Rails.application.routes.draw do
  devise_for :users

  mount ActionCable.server => '/cable'
  resources :urls, only: %i[new index]

  post 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'
  get 'batch/stats', to: 'batch_metrics#batch_stats'
  get 'batch/upload_status', to: 'batch_metrics#upload_status'
  # post 'batch/upload_status', to: 'batch_metrics#upload_status'
  post 'batch_urls', to: 'batch_metrics#batch_urls'

  root 'urls#index'
end
