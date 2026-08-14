class TermsController < ApplicationController
  # 1. Pula a trava da LGPD (senão daria loop infinito, pois ele já está bloqueado)
  skip_before_action :check_term_acceptance
  
  # 2. Pula a trava do Pundit (qualquer usuário logado pode e DEVE acessar essa tela)
  skip_after_action :verify_authorized

  # Rota GET: Mostra a tela com o texto do termo
  def pending
    @current_term = PolicyTerm.find_by(active: true)
    
    # Se não tem termo ativo, manda pra Home
    redirect_to root_path unless @current_term 
  end

  # Rota POST: A ação invisível quando ele clica no botão "Eu Aceito"
  def accept
    @current_term = PolicyTerm.find_by(active: true)

    if @current_term
      # Cria o contrato e salva o IP e a Data automaticamente
      UserAgreement.create!(
        user: current_user,
        policy_term: @current_term,
        accepted_at: Time.current,
        ip_address: request.remote_ip
      )
      flash[:notice] = "Obrigado por aceitar os Termos de Uso vigentes."
    end

    redirect_to root_path
  end
end