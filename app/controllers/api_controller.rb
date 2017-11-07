class ApiController < ActionController::API
  before_action :authenticate_request

  attr_accessor :current_user

  private

  def authenticate_request
    Auth::AuthorizeApiRequest.call(request) do
      on(:ok) { |user| self.current_user = user }
      on(:error) do |msg|
        logger.error(msg)
        render status: 401
      end
    end
  end
end

