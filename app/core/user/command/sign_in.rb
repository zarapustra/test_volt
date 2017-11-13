class User::Command::SignIn < Rectify::Command
  def initialize(params = {})
    @params = params
    @user = User.find_by(email: params[:email])
  end

  def call
    return broadcast(:error, form.errors) unless @user && form.valid?
    return broadcast(:ok, token) if token
    broadcast(:error, 'Problem with encrypting token')
  end

  private

  attr_reader :params, :user

  def form
    @_form ||= User::Form::SignInForm.from_params(params).with_context(user: user)
  end

  def token
    @_token ||= JsonWebToken.encode(user_id: user.id)
  end
end
