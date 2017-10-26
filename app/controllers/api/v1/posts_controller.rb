class Api::V1::PostsController < ApplicationController

  def create
    Post::Command::Create.call(params, current_user) do
      on(:ok) { |post| render json: {auth_token: token} }
      on(:error) do |msg|
        logger.error(msg)
        render status: 401
      end
    end
  end
end
