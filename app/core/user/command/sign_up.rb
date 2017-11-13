class User::Command::SignUp < Rectify::Command
  attr_reader :form, :msg_error

  def initialize(params = {})
    @form = User::Form::SignUpForm.from_params(params)
    @msg_error = nil
  end

  def call
    return broadcast(:invalid, form.errors) unless form.valid?
    return broadcast(:error, msg_error) unless user
    broadcast(:ok)
  end

  private

  def user
    User.create(form.attributes)
  rescue => e
    @msg_error = "Error, creating user: #{e.message}"
    false
  end
end
