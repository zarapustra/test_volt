class User::Command::Update < ApiCommand
  attr_reader :user, :form, :msg_error

  # TODO refactor
  def initialize(params = {})
    @current_user = params[:current_user]
    @user ||= params[:id].present? ? user!(params[:id]) : @current_user
    @form = User::Form::UpdateForm.from_params(params).with_context(user: user)
    @msg_error = nil
  end

  def call
    return broadcast(:unauthorized) unless authorize!
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

  def authorize!
    Pundit.policy(@current_user, user)&.update?
  end
end
