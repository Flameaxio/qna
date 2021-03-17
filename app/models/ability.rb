# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        can :manage, :all
      else
        can :read, :all
        can :create, [Question, Answer, Attachment]
        can :update, [Question, Answer], user_id: user.id
        can :destroy, [Question, Answer, Attachment], user_id: user.id
        can :upvote, Answer
        can :downvote, Answer
        can :comment_answer, Comment
        can :comment_question, Comment
        can :set_best, Answer do |answer|
          question = answer.question
          question.user_id == user.id
        end
      end
    else
      can :read, :all
    end
  end
end
