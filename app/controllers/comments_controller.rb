class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[comment_question]
  before_action :find_answer, only: %i[comment_answer]

  after_action :publish_question_comment

  authorize_resource :question
  authorize_resource :answer
  authorize_resource :comment

  def publish_question_comment
    return if @comment.errors.any?

    json = @comment.attributes.merge('email' => @comment.user.email)
    ActionCable.server.broadcast 'comments_channel', json
  end

  def comment_question
    @comment = @question.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  def comment_answer
    @comment = @answer.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :question_id, :answer_id)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:answer_id])
  end
end
