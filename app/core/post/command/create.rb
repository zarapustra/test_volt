class Post::Command::Create < Rectify::Command
  def initialize(params)
    @params = params
  end

  def call
    return broadcast(:error, form.errors) if form.invalid?
    broadcast(:ok, presenter)
  end

  private

  def presenter
    Post::PostPresenter.new(post: model)
  end

  def model
    Post.create(form.attributes)
  end

  def form
    @_form ||= Post::PostForm.from_params(@params)
  end
end
