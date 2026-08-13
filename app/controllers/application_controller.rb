class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  # Trava toda a aplicação. Ninguém acessa sem estar logado.
  before_action :authenticate_user!
  
  # Define o layout baseado na regra de negócio abaixo
  layout :layout_by_resource

  # Chama o filtro de segurança de parâmetros sempre que acionar o Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      profile_attributes: [:first_name, :last_name, :phone]
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      profile_attributes: [
        :id, :first_name, :last_name, :phone, :bio, :avatar_url,
        address_attributes: [:id, :street, :number, :complement, :city, :state, :zip_code]
      ]
    ])
  end

  private

  def layout_by_resource
    if devise_controller?
      # EXCEÇÃO: Se for a tela de editar/atualizar perfil, usa o layout principal (Sidebar + Header)
      if resource_name == :user && action_name.in?(%w[edit update])
        "application"
      else
        "devise" # Telas de Login, Cadastro, Recuperar Senha
      end
    else
      "application" # Todo o resto do sistema
    end
  end
end