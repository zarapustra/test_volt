class Api::V1::PostsController < ApplicationController

  def create
    Post::Command::Create.call(params) do
      on(:ok) { |presenter| render json: presenter.to_json }
      on(:error) { |errors| render status: 422, json: {errors: errors} }
    end
  end
end
