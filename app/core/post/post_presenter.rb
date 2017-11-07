class Post
  class PostPresenter < Rectify::Presenter
    attribute :post, Post

    def to_json
      {
        id: post.id,
        title: post.title,
        body: post.body,
        published_at: post.published_at.to_formatted_s(:datetime),
        author_nickname: post.user.nickname
      }
    end
  end
end
