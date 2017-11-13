class User::Form::SignUpForm < Rectify::Form
  attribute :email, String
  attribute :password, String
  attribute :nickname, String
  attribute :avatar, String

  validates :email, :password, :nickname, presence: true
  validates :password, length: {minimum: 8}
  validates :nickname, format: { without: /\s/ }
  validate :email_unique?, :nickname_unique?

  private

  def before_validation
    assign_avatar!
    downcase_nickname!
    downcase_email!
  end

  def assign_avatar!
    return unless avatar.present?
    self.avatar = File.open(avatar)
  end

  def downcase_nickname!
    self.nickname = nickname&.downcase
  end

  def downcase_email!
    self.email = email&.downcase
  end

  def email_unique?
    return unless User.find_by(email: email)
    errors.add(:email, 'Already in use')
  end

  def nickname_unique?
    return unless User.find_by(nickname: nickname)
    errors.add(:nickname, 'Already in use')
  end
end
