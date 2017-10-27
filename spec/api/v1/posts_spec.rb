require 'rails_helper'

describe 'POST/GET /posts/1' do
  URL = '/api/v1/posts'
  nickname = AuthenticationHelpers::CREDENTIALS[:nickname]
  params = {
    title: 'Title',
    body: 'Body'
  }
  it 'create post WITHOUT time sent' do
    now = Time.current.to_formatted_s(:datetime)

    post URL, params, headers
    expect_status(200)

    expect(json['title']).to eq(params[:title])
    expect(json['body']).to eq(params[:body])
    expect(json['author_nickname']).to eq(nickname)
    expect(json['published_at']).to eq(now)
  end

  it 'create post WITH time sent' do
    time = 1.year.ago.to_formatted_s(:datetime)
    params_with_time = params.merge(published_at: time)

    post URL, params_with_time, headers
    expect_status(200)

    expect(json['title']).to eq(params[:title])
    expect(json['body']).to eq(params[:body])
    expect(json['author_nickname']).to eq(nickname)
    expect(json['published_at']).to eq(time)
  end

  it 'return errors if form invalid' do
    post URL, {}, headers
    expect_status(422)
    expect(json['errors']['title']).to eq(['can\'t be blank'])
    expect(json['errors']['body']).to eq(['can\'t be blank'])
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
#     get URL
#     expect(last_response.body).to eq(posts_json)
#   end
# end