class User::Request::FindByNickname < Rectify::Query
  def initialize(nickname)
    @nickname = nickname
  end

  def query
    User.where(
      'lower(nickname) = lower(:nickname)', nickname: @nickname
    ).first
  end
end
