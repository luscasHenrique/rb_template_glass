class ScheduleDelegationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_delegation, only: [:destroy]

  def index
    # 1. GATILHO DE SEGURANÇA: Avisa o Pundit que estamos validando a regra
    authorize ScheduleDelegation
    
    # 2. Lista de assistentes atuais do usuário logado
    @delegations = current_user.delegations_given.includes(delegate: :profile)
    
    # 3. Prepara a lista para o Select (exclui o próprio usuário e quem já é assistente)
    existing_delegate_ids = @delegations.pluck(:delegate_id)
    excluded_ids = [current_user.id] + existing_delegate_ids
    
    @available_users = User.includes(:profile)
                           .where.not(active: false)
                           .where.not(id: excluded_ids)
                           .map do |u| 
                             nome = u.profile ? "#{u.profile.first_name} #{u.profile.last_name}" : "Sem Perfil"
                             ["#{nome} (#{u.email})", u.id]
                           end
  end

def create
    # GATILHO DE SEGURANÇA
    authorize ScheduleDelegation
    
    # 1. Captura o array de IDs enviado pelo multi_select e remove itens em branco
    delegate_ids = Array(params.dig(:schedule_delegation, :delegate_id)).reject(&:blank?)
    
    if delegate_ids.any?
      # 2. Itera sobre a lista e cria a permissão (find_or_create_by previne duplicidade no banco)
      delegate_ids.each do |id|
        current_user.delegations_given.find_or_create_by(delegate_id: id)
      end
      
      redirect_to schedule_delegations_path, notice: "Acesso concedido com sucesso a #{delegate_ids.count} usuário(s)."
    else
      redirect_to schedule_delegations_path, alert: "Por favor, selecione pelo menos um usuário na lista."
    end
  end

  def destroy
    # GATILHO DE SEGURANÇA (Valida o registro específico)
    authorize @delegation
    
    # Trava de segurança extra: Garante que o usuário só apague delegações da própria agenda
    if @delegation.delegator_id == current_user.id
      @delegation.destroy
      redirect_to schedule_delegations_path, notice: "Acesso revogado. O usuário não pode mais gerenciar sua agenda."
    else
      redirect_to schedule_delegations_path, alert: "Ação não permitida (Violação de Segurança)."
    end
  end

  private

  def set_delegation
    @delegation = ScheduleDelegation.find(params[:id])
  end

  def delegation_params
    params.require(:schedule_delegation).permit(:delegate_id)
  end
end