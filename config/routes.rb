require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(user), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USER"])) &
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end

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
  # post 'batch/upload_status', to: 'batch_metrics#upload_status'
  post 'batch_urls', to: 'batch_metrics#batch_urls'

  root 'urls#index'
end
