shared_examples 'API Authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(type)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if there is wrong access_token' do
      do_request(type, access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end
