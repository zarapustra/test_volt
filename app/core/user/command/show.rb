class User::Command::Show < Rectify::Command
  attr_reader :user

  def initialize(params)
    @user ||= User.find_by(id: params[:id])
  end

  def call
    return broadcast(:not_found) unless user
    broadcast(:ok, presenter)
  end

  private

  def presenter
    User::UserPresenter.new(user: user)
  end
end