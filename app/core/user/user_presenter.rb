class User::UserPresenter < Rectify::Presenter
  attribute :user, User
  include Url

  def to_json
    {
      id: user.id,
      nickname: user.nickname,
      email: user.email,
      avatar: {
        thumb: Url.full_url(user.avatar&.thumb&.url),
        full: Url.full_url(user.avatar&.url)
      },
      admin: user.admin
    }
  end
end
