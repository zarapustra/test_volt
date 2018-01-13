class User::Command::Show < ApiCommand
  attr_reader :user

  def initialize(params)
    @current_user = params[:current_user]
    @user ||= params[:id].present? ? user!(params[:id]) : @current_user
  end

  def call
    return broadcast(:not_found) unless user
    return broadcast(:unauthorized) unless authorize!
    broadcast(:ok, presenter)
  end

  private

  def user!(id)
    User.find_by_id(id)
  end

  def presenter
    User::UserPresenter.new(user: user)
  end

  def authorize!
    Pundit.policy(@current_user, user)&.show?
  end
end
