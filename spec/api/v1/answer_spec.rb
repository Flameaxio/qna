require 'rails_helper'

describe 'Answers API' do
  context 'GET /:question_id/answers' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is wrong access_token' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w[id body].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  context 'GET answers/:id' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is wrong access_token' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question) }
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id title body created_at updated_at attachments comments].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to have_json_path("question/#{attr}")
        end
      end
      it 'has comment' do
        expect(response.body).to have_json_path('question/comments/0/body')
      end
      it 'has attachment' do
        expect(response.body).to have_json_path('question/attachments/0/file')
      end
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token) }
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers",\
             params: { format: :json, question: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there is wrong access_token' do
        post "/api/v1/questions/#{question.id}/answers",\
             params: { format: :json, question: attributes_for(:answer), access_token: '1234' }
        expect(response.status).to eq 401
      end

      it 'returns 403 status if user does not have enough permissions' do
        post "/api/v1/questions/#{question.id}/answers",\
             params: { format: :json, question_id: question.id, answer: attributes_for(:answer), access_token: access_token.token }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
      before do
        post "/api/v1/questions/#{question.id}/answers",\
             params: { format: :json, question_id: question.id, answer: attributes_for(:answer), access_token: access_token.token }
      end

      it 'returns created question' do
        expect(response.body).to have_json_path('answer')
      end

      %w[body].each do |attr|
        it "has #{attr}" do
          expect(response.body).to \
            be_json_eql(question.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end
end
