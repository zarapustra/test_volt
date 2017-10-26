require 'rails_helper'

describe 'Sessions', type: :request do
  context do
    params = {
      email: 'zarapustra@volt.org',
      password: '12345678'
    }
    let!(:user) { User.create(params) }
    let(:expected_token) { JsonWebToken.encode(user_id: user.id) }

    it 'POST /sessions/sign_in' do
      sign_in!(params)
      expect_200
      enc_token = json['auth_token']
      user_id = JsonWebToken.decode(enc_token)[:user_id]
      expect(user_id).to eq(user.id)
    end

    it 'GET protected resource' do
      sign_in!(params)
      expect_200
      get '/test_token', @headers
      expect_200
      expect(json['works']).to be_truthy
    end
  end
end
