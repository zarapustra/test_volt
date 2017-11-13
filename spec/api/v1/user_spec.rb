require 'rails_helper'

describe 'User', type: :request do

  it 'POST /api/v1/sign_up' do
    params = {
      email: Faker::Internet.email,
      password: Faker::Internet.password(10, 20),
      nickname: 'creator',
      avatar: Rails.root.join('spec', 'support', 'one.jpg')
    }
    post '/api/v1/sign_up', params
    expect_status(201)
    user = User.last
    expect(user.avatar.url).to include('one.jpg')
  end

  it 'POST /api/v1/sign_in' do
    sign_in!
    expect_status(200)
    user_id = JsonWebToken.decode(@token)[:user_id]
    expect(user_id).to eq(@user.id)
  end

  it 'PUT /api/v1/users' do
    sign_in!
    expect_status(200)
    expect(@user.avatar.url).to include('one.jpg')

    params = {
      avatar: Rails.root.join('spec', 'support', 'two.jpg')
    }
    put "api/v1/users/#{@user.id}", params, @headers
    expect_status(204)
    expect(@user.reload.avatar.url).to include('two.jpg')
  end

  it 'doesn\'t update user when you send txt file as avatar' do
    params = {
      avatar: Rails.root.join('spec', 'support', 'mailer.txt')
    }
    sign_in!
    expect_status(200)
    put "api/v1/users/#{@user.id}", params, @headers
    expect(@user.avatar.url).to include('one.jpg')
  end

  it 'can update nickname' do
    sign_in!
    expect_status(200)
    put "api/v1/users/#{@user.id}", { nickname: 'dude' }, @headers
    expect_status(204)
    expect(@user.reload.nickname).to eq('dude')
  end

  it 'will not update invalid nickname' do
    sign_in!
    expect_status(200)
    put "api/v1/users/#{@user.id}", { nickname: 'chuck norris' }, @headers
    expect_status(422)
    expect(json['errors']['nickname']).to eq(['is invalid'])
  end

  it 'will not update not unique nickname' do
    User.create(
      email: Faker::Internet.email,
      password: Faker::Internet.password(10, 20),
      nickname: 'chuck_norris'
    )
    sign_in!
    expect_status(200)
    put "api/v1/users/#{@user.id}", { nickname: 'chuck_norris' }, @headers
    expect_status(422)
    expect(json['errors']['nickname']).to eq(['Already in use'])

  end

  it 'will not render 422 if change nickname to same nickname' do
    sign_in!
    expect_status(200)
    put "api/v1/users/#{@user.id}", { nickname: 'creator' }, @headers
    expect_status(204)
  end
end
