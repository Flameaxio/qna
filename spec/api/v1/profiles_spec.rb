require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
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
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end
      %w[id email].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end
      %w[password encrypted_password].each do |attr|
        it "doesn't contain #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /me' do
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
      let!(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/all', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      it 'has ids of all the users from list' do
        users.each do |u|
          expect(response.body).to be_json_eql(u.id.to_json).at_path("#{u.id}/id")
        end
      end

      it "doesn't have authorized user" do
        expect(response.body).not_to have_json_path(me.id.to_s)
      end
    end
  end
end
