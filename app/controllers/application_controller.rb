class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!

  # 1. GATEKEEPER (LGPD): Trava global que exige o Aceite de Termos antes de qualquer navegação
  before_action :check_term_acceptance

  # 2. PUNDIT: Traz o motor de autorização
  include Pundit::Authorization

  # 3. ZERO TRUST: Obriga que toda ação tenha uma verificação de permissão, exceto telas do Devise
  after_action :verify_authorized, unless: :devise_controller?

  # 4. TRATAMENTO DE ACESSO: O que acontece se o usuário for bloqueado pelo Pundit?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # =====================================================================
  # 5. TRATAMENTO DE ERROS GLOBAIS (UX & Resiliência)
  # =====================================================================
  
  # Erro 404: Usuário digitou ID errado ou o dado foi apagado
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  # Erro 500: Erro grave de código (Só captura em Produção para não cegar os Devs)
  unless Rails.env.development?
    rescue_from StandardError, with: :handle_generic_error
  end

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

  # A Inteligência de Bloqueio da LGPD
  def check_term_acceptance
    return unless user_signed_in?
    return if devise_controller? || controller_name == 'terms'

    unless current_user.accepted_current_term?
      redirect_to terms_pending_path, alert: "Por favor, leia e aceite as novas Políticas da Empresa para continuar."
    end
  end

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

  # =====================================================================
  # MÉTODOS DE RESPOSTA AOS ERROS (A Política de Redirecionamento)
  # =====================================================================

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para acessar esta área."
    redirect_based_on_auth_status
  end

  def handle_record_not_found
    flash[:alert] = "O registro que você tentou acessar não existe mais ou foi removido."
    redirect_based_on_auth_status
  end

  def handle_generic_error(exception)
    # 1. Registra o erro silenciosamente nos logs do Servidor para a TI consertar
    Rails.logger.error "💥 [ERRO GRAVE CAPTURADO]: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    
    # Futuramente, aqui podemos plugar ferramentas como Sentry ou Rollbar

    # 2. Avisa o usuário sem assustá-lo com códigos técnicos
    flash[:alert] = "Ocorreu uma instabilidade interna no sistema. Nossa equipe de engenharia já foi notificada."
    redirect_based_on_auth_status
  end

  # O Motor de Decisão de Rota que você solicitou
  def redirect_based_on_auth_status
    if user_signed_in?
      # Pode tentar voltar pra página anterior, ou joga na Home de forma segura
      redirect_to(request.referrer || root_path)
    else
      redirect_to new_user_session_path
    end
  end
end