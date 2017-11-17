class Report::ReportForm < Rectify::Form
  attribute :start_date, Date
  attribute :end_date, Date
  attribute :email, String

  validates :email, :start_date, :end_date, :presence => true
  validate :dates_valid?

  private

  def dates_valid?
    start_date.present? &&
      end_date.present? &&
      start_date_is_date? &&
      end_date_is_date? &&
      end_date_is_later?
  end

  def start_date_is_date?
    Date.parse(start_date)
  rescue ArgumentError
    errors.add(:start_date, 'is not valid date')
    false
  end

  def end_date_is_date?
    Date.parse(end_date)
  rescue ArgumentError
    errors.add(:end_date, 'is not valid date')
    false
  end

  def end_date_is_later?
    start_date <= end_date
  rescue false
    errors.add(:dates, 'Start date is later than end date')
    false
  end
end