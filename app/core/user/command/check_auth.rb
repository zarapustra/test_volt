class User::Command::CheckAuth < ApiCommand
  def initialize(request)
    @headers = request.env
  end

  def call
    return broadcast(:error, 'Invalid token') unless decoded_auth_token
    if user
      broadcast(:ok, user)
    else
      broadcast(:error, 'User not found')
    end
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find_by_id(decoded_auth_token[:user_id])
  end

  def decoded_auth_token
    @decoded_auth_token ||=
      token_from_header && JsonWebToken.decode(token_from_header)
  end

  def token_from_header
    headers['HTTP_AUTHORIZATION']&.split(' ')&.last
  end
end
