class User::UserPresenter < Rectify::Presenter
  attribute :user, User
  include Url

  def to_json
    {
      id: user.id,
      nickname: user.nickname,
      email: user.email,
      avatar: Url.full_url(user.avatar&.thumb&.url)
    }
  end
end
