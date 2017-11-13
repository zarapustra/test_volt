class User::Command::Update < Rectify::Command
  attr_reader :user, :form, :msg_error

  def initialize(params = {})
    @user = User.find(params[:id])
    @form = User::Form::UpdateForm.from_params(params).with_context(user: user)
    @msg_error = nil
  end

  def call
    return broadcast(:invalid, form.errors) unless user && form.valid?
    return broadcast(:error, msg_error) unless update_user!
    broadcast(:ok)
  end

  private

  def update_user!
    user.update(form.attributes)
  rescue => e
    @msg_error = "Error, updating user: #{e.message}"
    false
  end
end
