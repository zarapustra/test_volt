class User::Form::UpdateForm < Rectify::Form
  attribute :nickname, String
  attribute :avatar, String
  # change email and password separately in other commands

  validates :nickname, format: { without: /\s/ }
  validate :nickname_unique?

  private

  def before_validation
    assign_avatar!
    downcase_nickname!
  end

  def assign_avatar!
    return unless avatar.present?
    self.avatar = File.open(avatar)
  end

  def downcase_nickname!
    self.nickname = nickname&.downcase
  end

  def nickname_unique?
    return if same_nickname? || (not nickname_in_use?)
    errors.add(:nickname, 'Already in use')
  end

  def same_nickname?
    nickname.present? && context.user.nickname == self.nickname
  end

  def nickname_in_use?
    User.find_by(nickname: nickname)
  end
end

