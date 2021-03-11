class UserOpinion < ApplicationRecord
  validates_inclusion_of :opinion, in: -1..1
  belongs_to :user
  belongs_to :answer
end
