require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }
  context 'GET /:question_id/answers' do
    let!(:type) { :get }
    let!(:url) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authenticable'
    context 'authorized' do
      let!(:access_token) { create(:access_token) }
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
    let!(:answer) { create(:answer, question: question) }
    let!(:type) { :get }
    let!(:url) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }
      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id body attachments comments].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to have_json_path("answer/#{attr}")
        end
      end
      it 'has comment' do
        expect(response.body).to have_json_path('answer/comments/0/body')
      end
      it 'has attachment' do
        expect(response.body).to have_json_path('answer/attachments/0/file')
      end
    end
  end

  describe 'POST /create' do
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token) }
    let!(:type) { :post }
    let!(:url) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authenticable'
    context 'unauthorized' do
      it 'returns 403 status if user does not have enough permissions' do
        post url, \
             params: { format: :json, question_id: question.id, answer: attributes_for(:answer), access_token: access_token.token }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
      before do
        post "/api/v1/questions/#{question.id}/answers", \
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
