class ScheduleCategory < ApplicationRecord
  has_paper_trail
  has_many :schedule_items, dependent: :nullify
  
  validates :name, presence: true
end