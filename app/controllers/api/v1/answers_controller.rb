class Api::V1::AnswersController < Api::V1::BaseController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: :create

  def show
    respond_with Answer.find(params[:id]), adapter: :json, serializer: LoneAnswerSerializer
  end

  def index
    respond_with Answer.where(question_id: params[:question_id]), adapter: :json
  end

  def create
    if can?(:create, Answer)
      @answer = @question.answers.create(answer_params)
      render json: @answer, adapter: :json, serializer: AnswerSerializer
    else
      render json: { message: 'Not enough permissions' }, status: :forbidden
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params[:answer].try(:permit, :body)
  end
end
