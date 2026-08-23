class ScheduleItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # O usuário vê: eventos que ele criou OU eventos para os quais foi convidado
      scope.left_outer_joins(:schedule_guests)
           .where("schedule_items.creator_id = :user_id OR schedule_guests.user_id = :user_id", user_id: user.id)
           .distinct
    end
  end

  def index?
    true # Qualquer usuário logado pode ver seu próprio calendário (regido pelo Scope acima)
  end

  def show?
    is_owner_or_management? || is_guest?
  end

  def create?
    true # Qualquer usuário ativo pode tentar agendar
  end

  def edit?
    update?
  end

  def update?
    is_owner_or_management?
  end

  def destroy?
    is_owner_or_management?
  end

  private

  # A Regra de Ouro da Governança
  def is_owner_or_management?
    return false unless user.present?
    
    is_creator = record.creator_id == user.id
    is_management = user.admin? || user.manager? || user.master?

    is_creator || is_management
  end

  # Verifica se o usuário atual está na lista de convidados do evento
  def is_guest?
    record.guests.exists?(id: user.id)
  end
end