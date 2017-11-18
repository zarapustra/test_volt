class User::Command::Show < ApiCommand
  attr_reader :user

  def initialize(params)
    @current_user = params[:current_user]
    @user ||= User.find_by(id: params[:id])
  end

  def call
    return broadcast(:not_found) unless user
    return broadcast(:unauthorized) unless authorize!
    broadcast(:ok, presenter)
  end

  private

  def presenter
    User::UserPresenter.new(user: user)
  end

  def authorize!
    Pundit.policy(@current_user, user)&.show?
  end
end
