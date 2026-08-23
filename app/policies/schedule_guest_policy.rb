class ScheduleGuestPolicy < ApplicationPolicy
  # Apenas o próprio convidado pode dizer se vai ou não vai (Confirmar/Recusar)
  def update?
    record.user_id == user.id
  end

  # Apenas o dono do evento original (ou admin) pode remover alguém da lista
  def destroy?
    record.schedule_item.creator_id == user.id || user.admin?
  end
end