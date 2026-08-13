Rails.application.routes.draw do
  mount RailsIcons::Engine, at: "/rails_icons"
  # Rotas de Autenticação geradas pelo Devise
  devise_for :users

  # Rotas da UI
  resources :profiles

  # Rotas da API Versionada
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [ :index, :show ]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  # Define a página inicial do sistema
  root "home#index"
end
