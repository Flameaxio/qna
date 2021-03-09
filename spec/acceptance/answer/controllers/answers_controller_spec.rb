require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  let(:user) { create(:user) }

  setup do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question) }

    before { get :show, params: { question_id: question, id: answer } }

    it 'assigns the requested question to @question' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns new Question to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves the new question in the database' do
        expect{ create_request }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        create_request
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:create_request) { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }

      it 'doesnt save answer in db' do
        expect { create_request }.to_not change(Answer, :count)
      end

      it 'should redirect to new view' do
        create_request
        expect(response).to render_template :new
      end
    end
  end
end
