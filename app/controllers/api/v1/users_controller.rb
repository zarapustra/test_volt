class Api::V1::UsersController < ApiController
  skip_before_action :authenticate_request, only: [:sign_up]

  def sign_up
    User::Command::SignUp.call(params) do
      on(:ok) { render status: 201 }
      on(:invalid) { |errors| render status: 422, json: {errors: errors} }
      on(:error) do |msg|
        logger.error(msg)
        render status: 500
      end
      on(:unauthorized) { render status: 401 }
    end
  end

  def update
    User::Command::Update.call(params) do
      on(:ok) { render status: 204 }
      on(:invalid) { |errors| render status: 422, json: {errors: errors} }
      on(:error) do |msg|
        logger.error(msg)
        render status: 500
      end
      on(:unauthorized) { render status: 401 }
    end
  end

  def show
    User::Command::Show.call(params) do
      on(:ok) { |presenter| render json: presenter.to_json }
      on(:not_found) { render status: 404 }
      on(:unauthorized) { render status: 401 }
    end
  end
end
