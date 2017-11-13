class Post::Command::Show < Rectify::Command
  attr_reader :post

  def initialize(params)
    @post ||= Post.find_by(id: params[:id])
  end

  def call
    return broadcast(:not_found) unless post
    broadcast(:ok, presenter)
  end

  private

  def presenter
    Post::PostPresenter.new(post: post)
  end
end
