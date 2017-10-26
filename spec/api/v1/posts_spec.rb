require 'rails_helper'

describe 'POST/GET /posts/1' do
  post_params = {title: 'Title', body: 'Body', published_at: Time.current }
  # let(:post) { Post::Create.(post: post_params).model }

  it 'create post' do
    post '/api/v1/posts', post_params, headers
    expect_200
    expect(last_response.body).to eq(post_params.to_json)
  end
end

# describe 'GET /posts' do
#   let(:posts) do
#     20.times.collect do |i|
#       Post::Create.(post: {title: "Post #{i}", body: "Body #{i}"}).model
#     end
#   end
#   let(:posts_json) do
#     20.times.collect do |i|
#       {title: "Post #{i}", body: "Body #{i}"}.to_json
#     end
#   end
#
#   it 'renders' do
#     get '/api/v1/posts'
#     expect(last_response.body).to eq(posts_json)
#   end
# end