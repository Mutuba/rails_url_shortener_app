# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  resources :urls

  resources :batch_metrics, only: [:destroy]

  get '/batch_stats' => 'batch_metrics#batch_stats', as: :batch_stats
  get '/upload_status' => 'batch_metrics#upload_status', as: :upload_status
  get '/batch_urls' => 'batch_metrics#batch_urls', as: :batch_urls

  get '/download', => 'download_csv#download_sample_csv', as: :download_csv
  get 'home', => 'home#index', as: :home
  get 'rate_limit_exceeded', => 'errors#rate_limit_exceeded', as: :rate_limit_exceeded

  root 'urls#index'
end
