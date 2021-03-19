require 'acceptance/acceptance_helper'

RSpec.describe 'Questions API' do
  let!(:questions) { create_list(:question, 3).sort_by(&:created_at).reverse }
  let!(:question) { questions.first }
  let!(:access_token) { create(:access_token) }
  describe 'GET /index' do
    let!(:type) { :get }
    let!(:url) { '/api/v1/questions/' }
    it_behaves_like 'API Authenticable'
    context 'authorized' do
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path('questions')
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
  describe 'GET /show/:id' do
    let!(:type) { :get }
    let!(:url) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authenticable'
    context 'authorized' do
      let!(:answer) { create(:answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }
      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id body attachments comments].each do |attr|
        it "question object contains #{attr}" do
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
    let!(:type) { :post }
    let!(:url) { '/api/v1/questions' }
    it_behaves_like 'API Authenticable'
    context 'unauthorized' do
      it 'returns 403 status if user does not have enough permissions' do
        post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), access_token: access_token.token }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:question) { create(:question) }
      before do
        post '/api/v1/questions', \
             params: { format: :json, question: attributes_for(:question), access_token: access_token.token }
      end

      it 'returns created question' do
        expect(response.body).to have_json_path('question')
      end

      %w[title body].each do |attr|
        it "has #{attr}" do
          expect(response.body).to \
            be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end
end
