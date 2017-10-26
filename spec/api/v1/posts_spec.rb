require 'rails_helper'

RSpec.describe 'POST/GET /posts/1' do
  post_params = {title: 'Title', body: 'Body'}
  let(:post) { Post::Create.(post: post_params).model }
  it 'renders' do
    get "/api/v1/posts/#{ post.id }"
    expect(last_response.body).to eq(post_params.to_json)
  end
end

Rspec.describe 'GET /posts' do
  let(:posts) do
    20.times.collect do |i|
      Post::Create.(post: {title: "Post #{i}", body: "Body #{i}"}).model
    end
  end
  let(:posts_json) do
    20.times.collect do |i|
      {title: "Post #{i}", body: "Body #{i}"}.to_json
    end
  end

  it 'renders' do
    get '/api/v1/posts'
    expect(last_response.body).to eq(posts_json)
  end
end