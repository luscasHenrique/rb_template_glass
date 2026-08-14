class PolicyTermPolicy < ApplicationPolicy
  # REGRA: Apenas Admin e Master podem gerenciar os termos
  def gerenciar_termos?
    user.admin? || user.master?
  end

  def index?
    gerenciar_termos?
  end

  def show?
    gerenciar_termos?
  end

  def create?
    gerenciar_termos?
  end

  def new?
    create?
  end

  def update?
    gerenciar_termos? && record.user_agreements.empty?
  end

  def edit?
    update?
  end

  def destroy?
    # REGRA DE AUDITORIA: Ninguém apaga contrato antigo. Retorna sempre falso.
    false
  end
end