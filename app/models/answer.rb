class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question

  def user
    User.find(user_id).email
  end
end
