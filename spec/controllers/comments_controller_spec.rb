require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  sign_in_user
  context 'with valid attributes' do
    it 'saves the new question in the database' do
      expect do
        post :comment_question, params: \
        { comment: attributes_for(:comment), question_id: create(:question).id }
      end.to change(Comment, :count).by(1)
    end

  end
  context 'with invalid attributes' do
    it 'not saves the new comment in the database' do
      expect do
        post :comment_question, params: \
        { comment: attributes_for(:invalid_comment), question_id: create(:question).id }
      end.to_not change(Comment, :count)
    end
  end
end
