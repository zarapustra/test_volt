class User::AuthForm < Rectify::Form
  attribute :password, String

  validates :password, :presence => true
  validate :user_present?, :valid_password?

  def user_present?
    errors.add(:auth, 'No user found with this email') unless context.user.present?
  end

  def valid_password?
    errors.add(:auth, 'Password is incorrect') unless context.user.try(:authenticate, password)
  end
end
