class ScheduleItem < ApplicationRecord
  has_paper_trail
  
  belongs_to :creator, class_name: "User"
  belongs_to :schedule_category
  belongs_to :location, polymorphic: true, optional: true

  has_many :schedule_guests, dependent: :destroy
  has_many :guests, through: :schedule_guests, source: :user

  # O enum :item_type FOI REMOVIDO DAQUI

  validates :title, :start_time, presence: true
  validate :end_time_must_be_after_start_time

  private

  def end_time_must_be_after_start_time
    if start_time.present? && end_time.present? && end_time < start_time
      errors.add(:end_time, "não pode ser anterior ao horário de início")
    end
  end
end