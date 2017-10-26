module AuthenticationHelpers

  CREDENTIALS = {email: Faker::Internet.email, password: Faker::Internet.password(10, 20)}

  def credentials
    {email: Faker::Internet.email, password: Faker::Internet.password(10, 20)}
  end

  def sign_in!(params = CREDENTIALS)
    # basic_authorize params[:email], params[:password]
    # post '/authenticate', format: :json
    # @user = User.find_by(email: params[:email])
    @user = User.create(params)
    post '/authenticate', params, format: :json
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
