class Report::Command::ByAuthor < ApiCommand
  attr_reader :form

  def initialize(params)
    @current_user = params[:current_user]
    @form ||= Report::ReportForm.from_params(params)
  end

  def call
    return broadcast(:unauthorized) unless authorize!
    return broadcast(:ok, form.attributes) if form.valid?
    broadcast(:invalid, form.errors)
  end

  private

  def authorize!
    Pundit.policy(@current_user, :report)&.by_author?
  end
end
