class Post::Command::Show < Rectify::Command
  def initialize(params)
    @params = params
  end

  def call
    return broadcast(:not_found) unless model
    broadcast(:ok, presenter)
  end

  private

  def presenter
    Post::PostPresenter.new(post: model)
  end

  def model
    Post.find_by(id: @params[:id])
  end
end
