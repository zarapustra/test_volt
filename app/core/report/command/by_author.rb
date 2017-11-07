class Report::Command::ByAuthor < Rectify::Command
  def initialize(params)
    @form ||= Report::ReportForm.from_params(params)
  end

  def call
    return broadcast(:ok, @form.attributes) if @form.valid?
    broadcast(:error, @form.errors)
  end
end
