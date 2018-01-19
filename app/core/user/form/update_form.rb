class User::Form::UpdateForm < Rectify::Form
  include Base64Image
  attribute :nickname, String
  attribute :avatar, String
  #TODO change email and password separately in other commands

  private

  def before_validation
    validate_nickname
    validate_avatar
  end

  def validate_nickname
    self.nickname = context.user.nickname unless nickname.present?
    case
    when same_nickname?
      errors.add(:nickname, 'New nickname is the same as old')
    when nickname_in_use?
      errors.add(:nickname, 'Already in use')
    when nickname_with_spaces?
      errors.add(:nickname, 'Got spaces')
    else
      downcase_nickname!
    end
  end

  def validate_avatar
    assign_avatar!
  end

  def same_nickname?
    nickname.present? && context.user.nickname == self.nickname
  end

  def nickname_in_use?
    User.find_by(nickname: nickname)
  end

  def nickname_with_spaces?
    nickname =~ /\s/
  end

  def downcase_nickname!
    self.nickname = nickname&.downcase
  end

  def assign_avatar!
    return unless avatar.present?
    self.avatar = Base64Image.file_decode(avatar.split(',')[1], "user_id.#{context.user.id}-time.#{Time.now.to_i}.jpg")
  rescue => e
    errors.add(:nickname, "Server error: Base64 decoding went wrong: #{e}")
  end
end

