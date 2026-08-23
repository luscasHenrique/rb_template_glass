class ScheduleGuest < ApplicationRecord
  has_paper_trail
  belongs_to :schedule_item
  belongs_to :user

  # Aqui está o seu Enum de Status para o Convidado!
  enum :status, { pending: 0, confirmed: 1, declined: 2 }

  # Impede que o mesmo usuário seja convidado duas vezes para o mesmo evento
  validates :user_id, uniqueness: { scope: :schedule_item_id, message: "já está convidado para este evento" }
end