class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :delete_all
  has_many :user_opinions, dependent: :delete_all

  accepts_nested_attributes_for :attachments

  def user
    User.find(user_id).email
  end

  def total_score
    UserOpinion.where(answer_id: id).inject(0) { |sum, x| sum + x.opinion }
  end

  def current_user_opinion(current_user)
    UserOpinion.where(user_id: current_user.id, answer_id: id).first || 0
  end

  def increase_user_opinion(opinion)
    opinion.opinion = if opinion.opinion.zero?
                        1
                      elsif opinion.opinion == -1
                        1
                      else
                        0
                      end
    opinion.save
  end

  def decrease_user_opinion(opinion)
    opinion.opinion = if opinion.opinion.zero?
                        -1
                      elsif opinion.opinion == 1
                        -1
                      else
                        0
                      end
    opinion.save
  end

  def upvoted?(current_user)
    UserOpinion.where(user_id: current_user.id, answer_id: id).first.opinion == 1
  rescue StandardError
    false
  end

  def downvoted?(current_user)
    UserOpinion.where(user_id: current_user.id, answer_id: id).first.opinion == -1
  rescue StandardError
    false
  end
end
