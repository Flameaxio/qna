class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[upvote downvote]
  before_action :find_question
  before_action :find_answer, only: %i[update show destroy set_best upvote downvote]
  after_action :publish_answer, only: %i[create]

  authorize_resource :question
  authorize_resource :answer

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast('answers_channel',
                                 ApplicationController.render_with_signed_in_user(current_user,
                                                                                  'questions/_answer.html.slim',
                                                                                  locals: { answer: @answer,
                                                                                            question: @answer.question },
                                                                                  layout: false))

  end

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
    if user_signed_in?
      if current_user.email == @answer.user
        @answer.errors[:base] << "You can't vote for your answer!"
        respond_to do |format|
          format.json do
            render json: @answer.errors \
        , status: :unprocessable_entity
          end
        end
        return
      end
      @opinion = if @answer.user_opinions.where(user_id: current_user.id).any?
                   @answer.user_opinions.where(user_id: current_user.id).first
                 else
                   @answer.user_opinions.build(answer_id: @answer.id, user_id: current_user.id)
                 end
      @answer.increase_user_opinion(@opinion)
      @total_score = @answer.total_score
      @current_user_opinion = @answer.current_user_opinion(current_user) || 0
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'You need to log in for this action' }
      end
      return
    end
    respond_to do |format|
      format.json do
        render json: @answer.attributes.merge(\
          { 'current_user_opinion' => @current_user_opinion, 'total_score' => @total_score } \
        ), status: :ok
      end
    end
  end

  def downvote
    if user_signed_in?
      if current_user.email == @answer.user
        @answer.errors[:base] << "You can't vote for your answer!"
        respond_to do |format|
          format.json do
            render json: @answer.errors \
        , status: :unprocessable_entity
          end
        end
        return
      end
      @opinion = if @answer.user_opinions.where(user_id: current_user.id).any?
                   @answer.user_opinions.where(user_id: current_user.id).first
                 else
                   @answer.user_opinions.build(answer_id: @answer.id, user_id: current_user.id)
                 end
      @answer.decrease_user_opinion(@opinion)
      @total_score = @answer.total_score
      @current_user_opinion = @answer.current_user_opinion(current_user) || 0
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'You need to log in for this action' }
      end
      return
    end
    respond_to do |format|
      format.json do
        render json: @answer.attributes.merge(\
          { 'current_user_opinion' => @current_user_opinion, 'total_score' => @total_score } \
        ), status: :ok
      end
    end
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
