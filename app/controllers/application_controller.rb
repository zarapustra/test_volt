class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    Auth::AuthorizeApiRequest.call(params) do
      on(:ok) { |user| @current_user = user }
      on(:error) do |msg|
        logger.error(msg)
        render status: 401
      end
    end
  end
end

