class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user_from_token!

  respond_to :json

  def create
    respond Thing::Create, present: true
  end

  def show
    respond Post::Show, present: true
  end

  def index
    respond Post::Index, present: true
  end
end
