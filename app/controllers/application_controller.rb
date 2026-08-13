class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!

  # 1. PUNDIT: Traz o motor de autorização
  include Pundit::Authorization

  # 2. ZERO TRUST: Obriga que toda ação tenha uma verificação de permissão, exceto telas do Devise
  after_action :verify_authorized, unless: :devise_controller?

  # 3. TRATAMENTO: O que acontece se o usuário for bloqueado?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      profile_attributes: [ :first_name, :last_name, :phone ]
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      profile_attributes: [
        :id, :first_name, :last_name, :phone, :bio, :avatar_url,
        address_attributes: [ :id, :street, :number, :complement, :city, :state, :zip_code ]
      ]
    ])
  end

  private

  def layout_by_resource
    if devise_controller?
      if resource_name == :user && action_name.in?(%w[edit update])
        "application"
      else
        "devise"
      end
    else
      "application"
    end
  end

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para acessar esta área."
    redirect_to(request.referrer || root_path)
  end
end
