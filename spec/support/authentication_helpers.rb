module AuthenticationHelpers

  CREDENTIALS = {email: Faker::Internet.email, password: Faker::Internet.password(10, 20)}

  def credentials
    {email: Faker::Internet.email, password: Faker::Internet.password(10, 20)}
  end

  def register!(params = CREDENTIALS)
    post 'api/v1/sessions/sign_up', params, format: :json
  end

  def sign_in!(params = CREDENTIALS)
    # basic_authorize params[:email], params[:password]
    # post '/authenticate', format: :json
    post '/authenticate', params, format: :json
    @user = User.find_by(email: params[:email])
    @token = json['auth_token']
    @headers = {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(@token)
    }
  end

  def register_and_sign_in(params = CREDENTIALS)
    register!(params)
    sign_in!(params)
  end
end

RSpec.configure do |c|
  c.include AuthenticationHelpers, type: :request
end
