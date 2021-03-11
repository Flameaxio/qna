class AnswersController < ApplicationController
  before_action :find_question
  before_action :find_answer, only: %i[update show destroy set_best]

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def destroy
    respond_to do |format|
      format.js { @answer.destroy }
    end
  end

  def set_best
    Answer.where(question_id: @question.id).each do |x|
      x.best = false
      x.save
    end
    @answer.update(best: true)
  end

  def upvote

  end

  def downvote

  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :attachment_id, attachments_attributes: [:file])
  end
end
