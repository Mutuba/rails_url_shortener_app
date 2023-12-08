# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  devise_for :users
  # authenticate :user do
   mount Sidekiq::Web => '/sidekiq'
  # end
  mount ActionCable.server => '/cable'
  resources :urls, only: %i[new index]

  post 'urls/create', to: 'urls#create'
  get 'urls/show', to: 'urls#show'
  get 'batch/stats', to: 'batch_metrics#batch_stats'
  get 'batch/upload_status', to: 'batch_metrics#upload_status'
  get 'current_upload_status', to: 'batch_metrics#current_upload_status'
  get 'batch_urls', to: 'batch_metrics#batch_urls'
  post 'batch_urls', to: 'batch_metrics#batch_urls'
  get 'csv_import_sample/download', to: 'download_csv#download_sample_csv'
  get 'get_started', to: 'home#index'

  root 'urls#index'
end
