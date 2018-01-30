class User::Command::SignUp < ApiCommand
  attr_reader :form, :msg_error

  def initialize(params = {})
    @form = User::Form::SignUpForm.from_params(params)
    @msg_error = nil
  end

  def call
    return broadcast(:unauthorized) unless authorize!
    return broadcast(:invalid, form.errors) unless form.valid?
    return broadcast(:error, msg_error) unless user
    broadcast(:ok)
  end

  private

  def user
    @user ||= User.create(form.attributes)
  rescue => e
    @msg_error = "Creating user: #{e.message}"
    false
  end

  def authorize!
    Pundit.policy(nil, :user)&.sign_up?
  end
end
