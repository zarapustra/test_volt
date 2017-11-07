require 'rails_helper'

describe 'Sessions', type: :request do
  context do
    it 'POST /api/v1/authenticate' do
      sign_in!
      expect_status(200)
      user_id = JsonWebToken.decode(@token)[:user_id]
      expect(user_id).to eq(@user.id)
    end

    it 'GET protected resource' do
      sign_in!
      expect_status(200)
      get '/api/v1/test_token', nil, @headers
      expect_status(200)
      expect(json['works']).to be_truthy
    end
  end
end
