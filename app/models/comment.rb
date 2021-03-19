class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :body, presence: true
  validates :user, presence: true

  def route
    commentable.route
  end
end
