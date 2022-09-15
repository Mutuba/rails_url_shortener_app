Rails.application.routes.draw do
  resources :urls, only: %i[index new create show]
  get 'about', to: 'pages#about'
  # Defines the root path route ("/")
  root 'pages#home'
end
