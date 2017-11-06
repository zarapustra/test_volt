class Api::V1::PostsController < ApiController

  def create
    Post::Command::Create.call(params.merge user: current_user) do
      on(:ok) { |presenter| render json: presenter.to_json }
      on(:error) { |errors| render status: 422, json: {errors: errors} }
    end
  end

  def show
    Post::Command::Show.call(params) do
      on(:ok) { |presenter| render json: presenter.to_json }
      on(:not_found) { render status: 404 }
    end
  end

  def index
    Post::Command::Index.call(params) do
      on(:ok) do |json, total_pages, total_posts|
        response.set_header('Total-Pages', total_pages)
        response.set_header('Total-Posts', total_posts)
        render json: json
      end
    end
  end
end
