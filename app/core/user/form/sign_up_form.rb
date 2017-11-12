class User::Form::SignUpForm < Rectify::Form
  attribute :email, String
  attribute :password, String
  attribute :nickname, String

  validates :email, :password, :nickname, presence: true
  validates :password, length: {minimum: 8}
  validate :email_unique?, :nickname_unique?

  private

  def email_unique?
    return unless User::Request::FindByEmail.new(email).query
    errors.add(:email, 'Already in use')
  end

  def nickname_unique?
    return unless User::Request::FindByNickname.new(nickname).query
    errors.add(:nickname, 'Already in use')
  end
end
