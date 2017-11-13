class User::UserPresenter < Rectify::Presenter
  attribute :user, User

  def to_json
    {
      id: user.id,
      nickname: user.nickname,
      email: user.email,
      avatar: user.avatar.file&.thumb&.url
    }
  end
end
