class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers

  def short_body
    "#{body.truncate(57)}..."
  end
end
