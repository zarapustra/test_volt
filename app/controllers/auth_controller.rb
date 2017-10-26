class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: :log_in

  def log_in
    Auth::AuthenticateUser.call(params) do
      on(:ok) { |token| render json: {auth_token: token} }
      on(:error) do |msg|
        logger.error(msg)
        render status: 401
      end
    end
  end

  def test_token
    render json: {works: true}
  end
end
