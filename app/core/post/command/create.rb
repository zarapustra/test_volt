class Post::Command::Create < ApiCommand
  attr_reader :form

  def initialize(params)
    @current_user = params[:current_user]
    @form ||= Post::PostForm.from_params(params.merge(user: @current_user))
  end

  def call
    return broadcast(:unauthorized) unless authorize!
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

  def authorize!
    Pundit.policy(@current_user, :post)&.create?
  end
end
