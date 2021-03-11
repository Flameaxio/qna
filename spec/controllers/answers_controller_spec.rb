require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, user_id: user.id, question: question) }

  setup do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer.id, \
                                 question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer.id, question_id: question, \
                                 answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:create_request) do
        post :create, params: \
        { question_id: question, answer: attributes_for(:answer) }, format: :js
      end

      it 'saves the new question in the database' do
        expect { create_request }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:create_request) do
        post :create, params: \
        { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
      end

      it 'doesnt save answer in db' do
        expect { create_request }.to_not change(Answer, :count)
      end

      it 'should redirect to new view' do
        create_request
        expect(response).to render_template :create
      end
    end
  end
  describe 'DELETE #destroy' do
    sign_in_user
    before { answer }

    it 'deletes answer' do
      expect do
        delete :destroy, params: \
        { id: answer, question_id: question }, format: :js
      end.to change(Answer, :count).by(-1)
    end
  end
end
