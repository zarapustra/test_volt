require 'rails_helper'

describe 'POST/GET /posts/1' do
  url = '/api/v1/posts'
  nickname = AuthenticationHelpers::CREDENTIALS[:nickname]
  params = {
    title: 'Title',
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

describe 'GET /posts' do
  it 'shows existed post' do
    sign_in!
    Post::Command::Create.call(title: 'title', body: 'body', user: @user) do
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