Rails.application.routes.draw do
  resources :tracking_integrations
  # ---------------------------------------------------
  # 1. ROTAS DE LGPD E COMPLIANCE
  # ---------------------------------------------------
  get 'terms/pending', to: 'terms#pending', as: :terms_pending
  post 'terms/accept', to: 'terms#accept', as: :terms_accept # POST: Grava no banco com segurança
  
  resources :policy_terms # CRUD do painel de Gestão (Admin/Master)

  # ---------------------------------------------------
  # 2. ROTAS DE INFRAESTRUTURA E UI
  # ---------------------------------------------------
  mount RailsIcons::Engine, at: "/rails_icons"
  
  # Rotas de Autenticação geradas pelo Devise
  devise_for :users

  # Rotas das Telas do Sistema (HTML)
  resources :tracking_integrations, path: 'admin/integrations'

  # ---------------------------------------------------
  # 3. ROTAS DA API VERSIONADA (JSON)
  # ---------------------------------------------------
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [ :index, :show ]
    end
  end

  # ---------------------------------------------------
  # 4. ROTAS DE SISTEMA (Health Check e Root)
  # ---------------------------------------------------
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Define a página inicial do sistema
  root "home#index"
end