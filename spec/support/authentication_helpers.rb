module AuthenticationHelpers
  CREDENTIALS = {
    email: Faker::Internet.email,
    password: Faker::Internet.password(10, 20),
    nickname: 'Alex'
  }

  def sign_in!(params = CREDENTIALS)
    @user = User.create(params)
    post '/api/v1/authenticate', params, format: :json
    @token = json['auth_token']
    @headers = {
      'Authenticate' => "Token #{@token}"
    }
  end

  def headers(params = CREDENTIALS)
    sign_in!(params)
  end
end

RSpec.configure do |c|
  c.include AuthenticationHelpers, type: :request
end
