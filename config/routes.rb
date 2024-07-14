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

  namespace :batch_metrics do
    get :batch_stats
    get :upload_status
    get :batch_urls
  end

  get '/download', to: 'download_csv#download_sample_csv'
  get 'get_started', to: 'home#index'

  root 'urls#index'
end
