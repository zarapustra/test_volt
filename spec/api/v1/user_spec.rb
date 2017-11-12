require 'rails_helper'

describe 'User', type: :request do

  it 'POST /api/v1/sign_up' do
    params = {
      email: Faker::Internet.email,
      password: Faker::Internet.password(10, 20),
      nickname: 'creator'
    }
    post '/api/v1/sign_up', params
    expect_status(201)
  end
  it 'POST /api/v1/sign_in' do
    sign_in!
    expect_status(200)
    user_id = JsonWebToken.decode(@token)[:user_id]
    expect(user_id).to eq(@user.id)
  end
end
