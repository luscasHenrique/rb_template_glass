class UserAgreement < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :policy_term
end
