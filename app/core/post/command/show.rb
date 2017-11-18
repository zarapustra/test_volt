class Post::Command::Show < ApiCommand
  attr_reader :post

  def initialize(params)
    authorize(:post).index?
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
