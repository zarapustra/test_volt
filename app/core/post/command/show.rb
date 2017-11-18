class Post::Command::Show < ApiCommand
  attr_reader :post

  def initialize(params)
    @post ||= Post.find_by(id: params[:id])
    @current_user = params[:current_user]
  end

  def call
    return broadcast(:not_found) unless post
    return broadcast(:unauthorized) unless authorize!
    broadcast(:ok, presenter)
  end

  private

  def presenter
    Post::PostPresenter.new(post: post)
  end

  def authorize!
    Pundit.policy(@current_user, post)&.show?
  end
end
