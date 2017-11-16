class User::Command::SignIn < Rectify::Command

  def initialize(params = {})
    @params = params
    @user = User.find_by(email: params[:email])
    @msg_error = ''
  end

  def call
    return broadcast(:not_found) unless @user
    return broadcast(:invalid, form.errors) if form.invalid?
    update_time_offset!
    return broadcast(:ok, token) if token
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
    nil
  end

  def update_time_offset!
    time_offset_string = request.headers['X-Localtime'] || ''
    offset = parse_local_time_offset(time_offset_string)
    hours = val.to_i / 60
    if hours < -12 || hours > 14
      Rails.logger.warn "got #{offset} minutes offset for #{self}, reset to 0"
      val = 0
    end
    profile.try!(:offset_minutes=, val)
    profile.try!(:save!)
  rescue => e
    @msg_error = "Error, updating offset: #{e.message}"
    nil
  end
end
