class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers
end
