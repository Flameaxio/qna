class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new(question: @question) if user_signed_in?
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(questions_params)
    @question.user_id = current_user.id
    if @question.save
      redirect_to questions_path, notice: 'Your question was successfully published!'
    else
      render :new
    end
  end

  def update
    if @question.update(questions_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def questions_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
