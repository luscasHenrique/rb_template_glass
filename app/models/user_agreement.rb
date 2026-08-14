class UserAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :policy_term
end
