class TrackingIntegrationPolicy < ApplicationPolicy
  # Apenas cargos de altíssimo nível podem mexer em scripts de rastreamento (Risco de Segurança)
  def index?
    [ "admin", "master" ].include?(user.role)
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    create?
  end

  def update?
    index?
  end

  def edit?
    update?
  end

  def destroy?
    # Bloqueio total de exclusão para evitar quebrar o Analytics.
    # A recomendação é apenas inativar (is_active: false)
    [ "master" ].include?(user.role)
  end
end