class Post::Command::Create < ApiCommand
  attr_reader :form

  def initialize(params)
    authorize(:post).create?
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
