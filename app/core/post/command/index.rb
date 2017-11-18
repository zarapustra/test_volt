class Post::Command::Index < ApiCommand
  def initialize(params)
    @current_user = params[:current_user]
    @per = params[:per]
    @page = params[:page]
  end

  def call
    return broadcast(:unauthorized) unless authorize!
    broadcast(:ok, json, total_pages, total_posts)
  end

  private

  def json
    models.map do |model|
      Post::PostPresenter.new(post: model).to_json
    end
  end

  def models
    scope&.page(@page)&.per(@per)
  end

  def total_pages
    scope.page(1).per(@per).total_pages
  end

  def total_posts
    scope.count
  end

  def scope
    @scope ||= Pundit.policy_scope(@current_user, Post)
  end

  def authorize!
    Pundit.policy(@current_user, :post)&.index?
  end
end
