module Auth
  class AuthorizeApiRequest < Rectify::Command
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
      @user ||= User.find(decoded_auth_token[:user_id])
    end

    def decoded_auth_token
      @decoded_auth_token ||=
        http_auth_header &&
          JsonWebToken.decode(http_auth_header)
    end

    def http_auth_header
      headers['Authenticate'] && headers['Authenticate'].split(' ').last
    end
  end
end