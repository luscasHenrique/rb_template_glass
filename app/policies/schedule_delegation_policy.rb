class ScheduleDelegationPolicy < ApplicationPolicy
  def index?
    # Qualquer usuário ativo logado pode acessar a tela para gerenciar SUA própria agenda
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    # O Controller já trava para o delegator_id == current_user, 
    # mas o Pundit reforça a segurança na base.
    record.delegator_id == user.id
  end
end