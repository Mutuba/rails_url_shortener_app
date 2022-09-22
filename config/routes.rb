Rails.application.routes.draw do
  devise_for :users

  mount ActionCable.server => '/cable'
  resources :urls, only: %i[new index]

  post 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'
  get 'batch/stats', to: 'batch_metrics#batch_stats'
  get 'batch/download_status', to: 'batch_metrics#download_status'
  get 'batches', to: 'batch_metrics#index'
  get 'batch_urls', to: 'batch_metrics#batch_urls'

  root 'batch_metrics#index'
end
