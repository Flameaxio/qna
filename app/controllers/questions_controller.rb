class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy publish_question]

  after_action :publish_question, only: %i[create]

  def publish_question
    json = @question.attributes.merge('current_user' => (user_signed_in? ? current_user.to_json : '0'),\
                                      'short_body' => @question.short_body,\
                                      'question_path' => question_path(@question),\
                                      'user' => @question.user)
    ActionCable.server.broadcast 'question_channel', json
  end

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
    @question.update(questions_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def remove_attachment
    @question = Question.find(params[:id])
    Attachment.find(params[:attachment_id]).destroy
  end

  private

  def questions_params
    params.require(:question).permit(:title, :body, :attachment_id, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
