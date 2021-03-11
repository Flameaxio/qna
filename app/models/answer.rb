class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :delete_all
  has_many :user_opinions, dependent: :delete_all

  accepts_nested_attributes_for :attachments

  def user
    User.find(user_id).email
  end
end
