class Report::ReportForm < Rectify::Form
  attribute :start_date, Date
  attribute :end_date, Date
  attribute :email, String

  validates :email, :presence => true
  validate :dates_valid?

  private

  def dates_valid?
    start_date_is_valid? || end_date_is_valid? ||
       end_date_is_later?
  end

  def start_date_is_valid?
    errors.add(:start_date, 'invalid') unless start_date.is_a?(Date)
  end

  def end_date_is_valid?
    errors.add(:end_date, 'invalid') unless end_date.is_a?(Date)
  end

  def end_date_is_later?
    errors.add(:dates, 'Start date is later than end date') unless start_date <= end_date
  end
end