class Post::PostPresenter < Rectify::Presenter
  attribute :post, Post
  delegate :user, to: :post

  def to_json
    {
      id: post.id,
      title: post.title,
      body: post.body,
      published_at: post.published_at.in_time_zone(user.time_zone).to_formatted_s(:datetime),
      author_nickname: user.nickname
    }
  end
end
