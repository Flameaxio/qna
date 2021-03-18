class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :authenticate_user!, only: :create

  def index
    @questions = Question.all
    respond_with @questions, adapter: :json, each_serializer: QuestionSerializer
  end

  def show
    respond_with Question.find(params[:id]), adapter: :json, serializer: LoneQuestionSerializer
  end

  def create
    if can?(:create, Question)
      respond_with Question.create(question_params), adapter: :json
    else
      render json: { message: 'Not enough permissions' }, status: :forbidden
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
