Rails.application.routes.draw do
  # ---------------------------------------------------
  # 1. ROTAS DE LGPD E COMPLIANCE
  # ---------------------------------------------------
  get 'terms/pending', to: 'terms#pending', as: :terms_pending
  post 'terms/accept', to: 'terms#accept', as: :terms_accept
  
  resources :policy_terms

  # ---------------------------------------------------
  # 2. ROTAS DE INFRAESTRUTURA E UI
  # ---------------------------------------------------
  mount RailsIcons::Engine, at: "/rails_icons"
  devise_for :users
  resources :tracking_integrations, path: 'admin/integrations'

  # ---------------------------------------------------
  # 3. PAINEL DE ADMINISTRAÇÃO (BACKOFFICE GESTÃO)
  # ---------------------------------------------------
  namespace :admin do
    resources :users, only: [:index, :edit, :update] do
      member do
        get :audit_logs # Rota da Caixa Preta do PaperTrail
      end
    end
    resources :audit_logs, only: [:index]
  end

  # ---------------------------------------------------
  # 4. ROTAS DA API VERSIONADA (JSON)
  # ---------------------------------------------------
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [ :index, :show ]
    end
  end

  # ---------------------------------------------------
  # 5. ROTAS DE SISTEMA (Health Check e Root)
  # ---------------------------------------------------
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end