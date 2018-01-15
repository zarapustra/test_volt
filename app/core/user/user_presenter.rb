class User::UserPresenter < Rectify::Presenter
  attribute :user, User

  def to_json
    {
      id: user.id,
      nickname: user.nickname,
      email: user.email,
      avatar: base_url + user.avatar&.thumb&.url
    }
  end
end
