class Post::Command::Index < Rectify::Command
  def initialize(params)
    @per = params[:per]
    @page = params[:page]
  end

  def call
    broadcast(:ok, json, total_pages, total_posts)
  end

  private

  def json
    models.map do |model|
      Post::PostPresenter.new(post: model).to_json
    end
  end

  def models
    Post.page(@page).per(@per)
  end

  def total_pages
    Post.page(1).per(@per).total_pages
  end

  def total_posts
    Post.count
  end
end
