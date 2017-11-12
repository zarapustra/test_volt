class Api::V1::UsersController < ApiController
  skip_before_action :authenticate_request#, only: [:sign_up, :sign_in]


  def sign_up
    User::Command::SignUp.call(params) do
      on(:ok) { render status: 201 }
      on(:invalid) { |errors| render status: 422, json: { errors: errors } }
      on(:error) do |msg|
        logger.error(msg)
        render status: 500
      end
    end
  end

  def sign_in
    User::Command::SignIn.call(params) do
      on(:ok) { |token| render json: {auth_token: token} }
      on(:error) do |msg|
        logger.error(msg)
        render status: 401
      end
    end
  end
end