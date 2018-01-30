class User::Command::SignIn < ApiCommand

  def initialize(params = {})
    @params = params
    @user = User.find_by(email: params[:email])
    @msg_error = ''
  end

  def call
    return broadcast(:not_found) unless @user
    return broadcast(:invalid, form.errors) if form.invalid?
    update_time_zone!
    return broadcast(:ok, @user, token) if token
    broadcast(:error, @msg_error)
  end

  private

  attr_reader :params, :user
  attr_writer :msg_error

  def form
    @_form ||= User::Form::SignInForm.from_params(params).with_context(user: user)
  end

  def token
    @_token ||= JsonWebToken.encode(user_id: user.id)
  rescue => e
    @msg_error = "Error, encrypting token: #{e.message}"
    false
  end

  def update_time_zone! # TODO turn on
    hours = headers['UTC-OFFSET'].to_i / 60
    hours = 'UTC' if hours < -11 || hours > 13
    user.update_column(:time_zone, ActiveSupport::TimeZone[hours])
  rescue => e
    @msg_error = "Error, updating offset: #{e.message}"
    false
  end
end
