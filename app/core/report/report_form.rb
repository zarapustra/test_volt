class Report::ReportForm < Rectify::Form
  attribute :start_date, Date
  attribute :end_date, Date
  attribute :email, String

  validates :email, :start_date, :end_date, :presence => true
  validate  :dates_valid?

  private

  def dates_valid?
    valid = start_date.present? && end_date.present? && start_date <= end_date
    errors.add(:dates, 'Start date is later than end date') unless valid
  end
end