class AnswersController < ApplicationController
  before_action :find_question

  def show
    @answer = @question.answers.find(params[:id])
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to question_path(@question), notice: 'Successfully your published answer!'
    else
      render :new
    end
  end

  def destroy
    @answer.destroy
    redirect_to questions_path, notice: 'Successfully deleted your answer!'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
