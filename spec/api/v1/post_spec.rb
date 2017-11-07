require 'rails_helper'

describe 'POST/GET /posts/1' do
  url = '/api/v1/posts'
  nickname = AuthenticationHelpers::CREDENTIALS[:nickname]
  params = {
    title: 'POST/GET /posts/1',
    body: 'Body'
  }
  it 'create post WITHOUT time sent' do
    now = Time.current.to_formatted_s(:datetime)

    post url, params, headers
    expect_status(200)

    expect(json['title']).to eq(params[:title])
    expect(json['body']).to eq(params[:body])
    expect(json['author_nickname']).to eq(nickname)
    expect(json['published_at']).to eq(now)
  end

  it 'create post WITH time sent' do
    time = 1.year.ago.to_formatted_s(:datetime)
    params_with_time = params.merge(published_at: time)

    post url, params_with_time, headers
    expect_status(200)

    expect(json['title']).to eq(params[:title])
    expect(json['body']).to eq(params[:body])
    expect(json['author_nickname']).to eq(nickname)
    expect(json['published_at']).to eq(time)
  end

  it 'return errors if form invalid' do
    post url, {}, headers
    expect_status(422)
    expect(json['errors']['title']).to eq(['can\'t be blank'])
    expect(json['errors']['body']).to eq(['can\'t be blank'])
  end
end

describe 'GET /posts/:id' do
  it 'shows existed post' do
    sign_in!
    Post::Command::Create.call(title: 'GET /posts/:id', body: 'body', user: @user) do
      on(:ok) do |presenter|
        post = presenter.post
        get "/api/v1/posts/#{post.id}", nil, headers
        expect_status(200)
        expect(json['title']).to eq(post.title)
        expect(json['body']).to eq(post.body)
        expect(json['author_nickname']).to eq(post.user.nickname)
        expect(json['published_at']).to eq(post.published_at.to_formatted_s(:datetime))
      end
    end
  end

  it 'shows 404 when post non existed' do
    get '/api/v1/posts/2', nil, headers
    expect_status(404)
  end
end

describe 'GET posts' do
  it 'shows one page of posts' do
    sign_in!
    200.times do |i|
      Post::Command::Create.call(title: "GET posts: post_#{i}", body: i, user: @user)
    end
    get '/api/v1/posts', { per: 10, page: 1 }, headers
    expect_status(200)
    expect(json.size).to eq(10)
    expect(last_response.headers['Total-Pages']).to eq(20)
    expect(last_response.headers['Total-Posts']).to eq(200)

    expect(json.first['body']).to eq('0')
    expect(json.last['body']).to eq('9')

    get '/api/v1/posts', { per: 10, page: 5 }, headers
    expect_status(200)
    expect(json.first['body']).to eq('40')
    expect(json.last['body']).to eq('49')
  end
end