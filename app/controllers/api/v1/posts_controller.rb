class Api::V1::PostsController < ApplicationController

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
end
