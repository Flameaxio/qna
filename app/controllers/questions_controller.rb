class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy publish_question]
  before_action :find_answers, only: :show

  after_action :publish_question, only: %i[create]

  respond_to :js, :html

  authorize_resource :question
  authorize_resource :answer

  def publish_question
    return if @question.errors.any?

    json = @question.attributes.merge('current_user' => (user_signed_in? ? current_user.to_json : '0'),\
                                      'short_body' => @question.short_body,\
                                      'question_path' => question_path(@question),\
                                      'user' => @question.user)
    ActionCable.server.broadcast 'question_channel', json
  end

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(questions_params.merge('user_id'=>current_user.id)))
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  def remove_attachment
    @question = Question.find(params[:id])
    Attachment.find(params[:attachment_id]).destroy
  end

  def subscribe

  end

  private

  def questions_params
    params.require(:question).permit(:title, :body, :attachment_id, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def find_answers
    @answers = @question.answers
    @answer = Answer.new(question: @question) if user_signed_in?
  end
end
