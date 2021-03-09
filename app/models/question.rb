class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers, dependent: :delete_all

  def short_body
    "#{body.truncate(57)}..."
  end

  def user
    User.find(user_id).email
  end
end
