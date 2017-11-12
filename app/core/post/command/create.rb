class Post::Command::Create < Rectify::Command
  attr_reader :form

  def initialize(params)
    @form = Post::PostForm.from_params(params)
  end

  def call
    return broadcast(:invalid, form.errors) if form.invalid?
    broadcast(:ok, presenter)
  end

  private

  def presenter
    Post::PostPresenter.new(post: post)
  end

  def post
    Post.create(form.attributes)
  end
end
