class ApiController < ActionController::API
  before_action :authenticate_request

  attr_accessor :current_user

  private

  def authenticate_request
    User::Command::CheckAuth.call(request) do
      on(:ok) do |user|
        # self.current_user = user
        self.params.merge!(current_user: user)
      end
      on(:error) do |msg|
        logger.error(msg)
        render status: 401 # unauthenticated
      end
    end
  end
end

