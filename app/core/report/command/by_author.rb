class Report::Command::ByAuthor < ApiCommand
  def initialize(params)
    @params = params
  end

  def call
    return broadcast(:unauthorized) unless authorize!
    return broadcast(:ok, form.attributes) if form.valid?
    broadcast(:invalid, form.errors)
  end

  private

  attr_reader :params

  def form
    @form ||= Report::ReportForm.from_params(params)
  end

  def authorize!
    Pundit.policy(params[:user], :report)&.by_author?
  end
end
