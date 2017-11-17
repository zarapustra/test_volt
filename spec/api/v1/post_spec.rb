require 'rails_helper'
require Rails.root.join('spec', 'api', 'v1', 'shared_examples', 'responds_with.rb')

describe Api::V1::PostsController, type: :request do
  let(:url) { '/api/v1/posts' }
  let(:user) { create(:user) }

#------------------ CREATE --------------------------#
  describe 'POST api/v1/posts/1' do
    let(:params) { attributes_for(:post) }
    before { post url, params, headers(user) }

    context 'when all params valid' do
      it_behaves_like 'responds with', 201
      it 'renders params' do
        expect(json[:title]).to eq(params[:title])
        expect(json[:body]).to eq(params[:body])
        expect(json[:author_nickname]).to eq(user.nickname)
      end
      it 'renders current time at published_at' do
        expect(json[:published_at].to_time).to be_within(10.second).of Time.now
      end
    end

    context 'when time is sent' do
      let(:params) { attributes_for :old_post }

      it_behaves_like 'responds with', 201
      it 'renders it' do
        expect(json[:published_at].to_time).to be_within(5.second).of params[:published_at].to_time
      end
    end

    context 'when title is empty' do
      let(:params) { attributes_for(:post).merge(title: '') }

      it_behaves_like 'responds with', 422
      it 'renders error for title' do
        expect(json[:errors][:title]).to eq(['can\'t be blank'])
      end
    end

    context 'when body is empty' do
      let(:params) { attributes_for(:post).merge(body: '') }

      it_behaves_like 'responds with', 422
      it 'renders error for body' do
        expect(json[:errors][:body]).to eq(['can\'t be blank'])
      end
    end
  end
#------------------ /CREATE --------------------------#

#------------------ SHOW    --------------------------#
  describe 'GET /posts/:id' do
    before { get "/api/v1/posts/#{id}" }

    context 'when existed' do
      let(:post) { create(:old_post) }
      let(:id) { post.id }
      let(:expected_json) do
        {
          title: post.title,
          body: post.body,
          published_at: post.published_at.in_time_zone(user.time_zone).to_formatted_s(:datetime),
          author_nickname: post.user.nickname
        }
      end

      it_behaves_like 'responds with', 200
      it 'renders post json' do
        expect(json.except(:id)).to eq(expected_json)
      end
    end

    context 'when non existed' do
      let(:id) { 404 }

      it_behaves_like 'responds with', 404
      it 'renders nothing' do
        expect(last_response.body).to eq(' ')
      end
    end
  end
#------------------ /SHOW  --------------------------#

#------------------ INDEX --------------------------#
  describe 'GET posts' do
    let(:per) { 2 }
    let(:page) { 2 }
    let(:amount) { 5 }
    let!(:posts) { amount.times.map { create(:post) }}
    before { get '/api/v1/posts', { per: per, page: page }}

    it 'renders valid amount per page' do
      expect(json.size).to eq(per)
    end

    it 'renders valid page' do
      # 0,1 posts are on the first page
      expect(json[0][:id]).to eq(posts[2].id)
      expect(json[1][:id]).to eq(posts[3].id)
    end
    it 'has valid Total-Pages header' do
      expect(last_response.headers['Total-Pages']).to eq(3)
    end
    it 'has valid Total-Posts header' do
      expect(last_response.headers['Total-Posts']).to eq(amount)
    end
  end
end
