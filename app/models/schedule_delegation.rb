class ScheduleDelegation < ApplicationRecord
  has_paper_trail
  belongs_to :delegator, class_name: "User"
  belongs_to :delegate, class_name: "User"

  validates :delegate_id, uniqueness: { scope: :delegator_id, message: "já possui permissão para gerir esta agenda" }
end