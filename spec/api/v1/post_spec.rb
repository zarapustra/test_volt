require 'rails_helper'
require Rails.root.join('spec', 'api', 'v1', 'shared_examples', 'respond_with.rb')

describe Api::V1::PostsController, type: :request do
  let(:url) { '/api/v1/posts' }
  let(:user) { create(:user) }


#------------------ CREATE --------------------------#

  describe 'POST api/v1/posts/1' do
    let(:params) { {title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph} }

    before { post url, params, headers(user) }

    context 'when all params valid' do
      let(:now) { Time.current.to_formatted_s(:datetime) }
      let(:expected_json) do
        {
          title: params[:title],
          body: params[:body],
          published_at: now,
          author_nickname: user.nickname
        }
      end

      it_behaves_like 'respond with', 201
      it 'renders them' do
        expect(json.except(:id)).to eq(expected_json)
      end
      it 'renders current time at published_at' do
        expect(json[:published_at]).to eq(now)
      end

      it 'can get '
    end

    context 'when time is sent' do
      let(:time) { 1.year.ago.to_formatted_s(:datetime) }

      it_behaves_like 'respond with', 201
      it 'renders it' do
        expect(json.except(:id)).to eq(time)
      end
    end
    context 'when invalid params is' do
      context 'title' do
        let(:params) { params.merge(title: '') }

        it_behaves_like 'respond with', 422
        it 'renders error for title' do
          expect(json[:errors][:title]).to eq(['can\'t be blank'])
        end
      end

      context 'body' do
        let(:params) { params.merge(body: '') }

        it_behaves_like 'respond with', 422
        it 'renders error for body' do
          expect(json[:errors][:body]).to eq(['can\'t be blank'])
        end
      end
    end
  end

#------------------ /CREATE --------------------------#
#------------------  SHOW   --------------------------#

  describe 'GET /posts/:id' do
    let(:post) { create(:post_month_old) }
    let(:expected_json) do
      {
        title: post.title,
        body: post.body,
        published_at: post.published_at,
        author_nickname: post.author_nickname
      }
    end
    before { get "/api/v1/posts/#{post.id}" }

    context 'when existed' do
      it_behaves_like 'respond with', 200
      it 'renders post json' do
        expect(json.except(:id)).to eq(expected_json)
      end
    end

    context 'when non existed' do
      let(:post) { nil }

    end
    it 'shows existed post' do
      Post::Command::Create.call(title: 'GET /posts/:id', body: 'body', user: @user) do
        on(:ok) do |presenter|
          post = presenter.post
          get "/api/v1/posts/#{post.id}", nil, headers
          expect_status(200)
          expect(json[:title]).to eq(post.title)
          expect(json[:body]).to eq(post.body)
          expect(json[:author_nickname]).to eq(post.user.nickname)
          expect(json[:published_at]).to eq(post.published_at.to_formatted_s(:datetime))
        end
      end
    end

    it 'shows 404 when post non existed' do
      expect_status(404)
    end
  end

  describe 'GET posts' do
    it 'shows one page of posts' do
      sign_in!
      200.times do |i|
        Post::Command::Create.call(title: "GET posts: post_#{i}", body: i, user: @user)
      end
      get '/api/v1/posts', {per: 10, page: 1}, headers
      expect_status(200)
      expect(json.size).to eq(10)
      expect(last_response.headers['Total-Pages']).to eq(20)
      expect(last_response.headers['Total-Posts']).to eq(200)

      expect(json.first[:body]).to eq('0')
      expect(json.last[:body]).to eq('9')

      get '/api/v1/posts', {per: 10, page: 5}, headers
      expect_status(200)
      expect(json.first[:body]).to eq('40')
      expect(json.last[:body]).to eq('49')
    end
  end
end
