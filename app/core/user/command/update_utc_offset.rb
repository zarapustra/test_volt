class User::Command::UpdateUtcOffset < Rectify::Command

  def initialize(params = {})
    @user = params[:user]
  end

  def call
    return broadcast(:error, 'User is not valid user') unless @user.is_a? User
    if update_time_zone!
      broadcast(:ok)
    else
      broadcast(:error, @msg_error)
    end
  end

  private

  attr_reader :user

  def update_time_zone!
    hours = headers['UTC-OFFSET'].to_i / 60
    hours = 'UTC' if hours < -11 || hours > 13
    user.update_column(:time_zone, ActiveSupport::TimeZone[hours])
  rescue => e
    @msg_error = "While updating utc offset: #{e.message}, user_id: #{user.try(:id)}"
    false
  end
end
