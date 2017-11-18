require 'rails_helper'
require Rails.root.join('spec', 'api', 'v1', 'shared_examples', 'responds_with.rb')

describe nil, type: :request do

#------------------ SIGNUP --------------------------#
  describe 'POST /api/v1/sign_up' do
    let(:params) { attributes_for(:user) }

    before { post '/api/v1/sign_up', params }

    context 'all params are valid' do

      it_behaves_like 'responds with', 201
      it 'creates a user' do
        expect(User.count).to eq(1)
      end
    end

    context 'when invalid param is' do
      # TODO
    end
  end
#------------------ /SIGNUP --------------------------#

#------------------ SIGNIN --------------------------#
  describe 'POST /api/v1/sign_in' do
    let(:user) { create(:user) }
    let(:params) do
      {
        email: user.email,
        password: attributes_for(:user)[:password]
      }
    end
    before { post '/api/v1/sign_in', params, {'UTC-OFFSET' => 360} }

    it_behaves_like 'responds with', 200
    it 'renders valid token' do
      expect(json[:auth_token]).to eq(token! user)
    end

    # TODO not found
    # TODO form errors
    # TODO offset
  end
#------------------ /SIGNIN --------------------------#

#------------------ UPDATE --------------------------#
  describe 'PUT /api/v1/users' do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }

    context 'when is_client &' do
      before { put "api/v1/users/#{user.id}", params, headers(user) }

      context 'avatar is' do
        context 'valid' do
          let(:params) { {avatar: Rails.root.join('spec', 'support', 'two.jpg')} }

          it_behaves_like 'responds with', 204
          it 'renders url of new image' do
            expect(user.reload.avatar.url).to include('two.jpg')
          end
        end

        context 'not image' do
          let(:params) { {avatar: Rails.root.join('spec', 'support', 'mailer.txt')} }

          it 'doesn\'t change avatar' do
            expect(user.avatar.url).to include('one.jpg')
          end
        end
      end

      context 'nickname is' do
        context 'valid' do
          let(:params) { {nickname: 'dude'} }

          it_behaves_like 'responds with', 204
          it 'renders new nickname' do
            expect(user.reload.nickname).to eq(params[:nickname])
          end
        end

        context 'with spaces' do
          let(:params) { {nickname: 'Space Cowboy'} }

          it_behaves_like 'responds with', 422
          it 'renders error' do
            expect(json[:errors][:nickname]).to eq(['is invalid'])
          end
        end

        context 'not unique' do
          let(:params) { {nickname: second_user.nickname} }

          it_behaves_like 'responds with', 422
          it 'renders error' do
            expect(json[:errors][:nickname]).to eq(['Already in use'])
          end
        end

        context 'same as it was' do
          let(:params) { {nickname: user.nickname} }

          it_behaves_like 'responds with', 204
        end
      end
    end

    context 'when is_admin & params are valid' do
      let(:admin) { create(:admin) }
      let(:params) do
        {
          avatar: Rails.root.join('spec', 'support', 'two.jpg'),
          nickname: 'dude'
        }
      end
      before { put "api/v1/users/#{user.id}", params, headers(admin) }

      it_behaves_like 'responds with', 204
      it 'renders url of new image' do
        expect(user.reload.avatar.url).to include('two.jpg')
      end
      it 'renders new nickname' do
        expect(user.reload.nickname).to eq(params[:nickname])
      end
    end

    context 'when is_client but different' do
      let(:params) { nil }
      before { put "api/v1/users/#{user.id}", params, headers(second_user) }

      it_behaves_like 'responds with', 401
      it 'renders nothing' do
        expect(last_response.body).to eq(' ')
      end
    end

    context 'when is_guest' do
      before { put "api/v1/users/#{user.id}" }

      it_behaves_like 'responds with', 401
      it 'renders nothing' do
        expect(last_response.body).to eq(' ')
      end
    end
  end
end
