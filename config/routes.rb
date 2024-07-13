# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  resources :urls, only: %i[new show index create update edit]

  namespace :batch_metrics do
    get :batch_stats
    get :upload_status
    match :batch_urls, via: %i[get post]
  end

  get '/download', to: 'download_csv#download_sample_csv'
  get 'get_started', to: 'home#index'

  root 'urls#index'
end
