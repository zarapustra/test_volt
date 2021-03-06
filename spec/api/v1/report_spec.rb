require 'rails_helper'
require 'sidekiq/testing'
require Rails.root.join('spec', 'api', 'v1', 'shared_examples', 'responds_with.rb')
require Rails.root.join('spec', 'api', 'v1', 'shared_examples', 'blank_message')
require Rails.root.join('spec', 'api', 'v1', 'shared_examples', 'invalid_message')

describe 'GET /api/v1/reports/by_author', type: :request do
  let(:today) { Date.today.to_s }
  let(:tomorrow) { Date.tomorrow.to_s }
  let(:start_date) { today }
  let(:end_date) { tomorrow }
  let(:email) { 'reports@example.com' }
  let(:params) do
    {
      start_date: start_date,
      end_date: end_date,
      email: email
    }
  end
  let(:url) { '/api/v1/reports/by_author' }
  let(:user) { create(:user) }
  before { get url, params, headers(user) }

  context 'when is_admin &' do
    let(:user) { create(:admin) }

    context 'all params are valid' do
      it_behaves_like 'responds with', 200
      it 'renders specific message' do
        expect(json[:message]).to eq('Report generation started')
      end
      it 'enqueues generating job' do
        expect(Report::ByAuthorWorker).to have_enqueued_sidekiq_job(params)
      end
    end

    context 'start_date is' do
      context 'later than end_date' do
        let(:start_date) { tomorrow }
        let(:end_date) { today }

        it_behaves_like 'responds with', 422
        it 'renders error' do
          expect(json[:errors][:dates]).to eq(['Start date is later than end date'])
        end
      end

      context 'nil' do
        let(:start_date) { nil }

        it_behaves_like 'responds with', 422
        it_behaves_like 'renders invalid message', :start_date
      end

      context 'not date' do
        let(:start_date) { 'qwerty' }

        it_behaves_like 'responds with', 422
        it_behaves_like 'renders invalid message', :start_date
      end
    end

    context 'end_date is' do
      context 'nil' do
        let(:end_date) { nil }

        it_behaves_like 'responds with', 422
        it_behaves_like 'renders invalid message', :end_date
      end

      context 'invalid date' do
        let(:end_date) { 'qwerty' }

        it_behaves_like 'responds with', 422
        it_behaves_like 'renders invalid message', :end_date
      end
    end

    context 'email is' do
      context 'nil' do
        let(:email) { nil }

        it_behaves_like 'responds with', 422
        it_behaves_like 'renders blank message', :email
      end

      context 'not valid email' do
        let(:email) { 'qwerty' }

        # TODO
        # it_behaves_like 'responds with', 422
        # it_behaves_like 'renders invalid message', :email
      end
    end
  end

  context 'when is_client' do
    it_behaves_like 'responds with', 401

    it 'renders no message' do
      expect(last_response.body).to eq(' ')
    end
    it 'doesn\'t enqueue generating job' do
      expect(Report::ByAuthorWorker).not_to have_enqueued_sidekiq_job(params)
    end
  end

  context 'when is_guest' do
    it_behaves_like 'responds with', 401

    it 'renders no message' do
      expect(last_response.body).to eq(' ')
    end
    it 'doesn\'t enqueue generating job' do
      expect(Report::ByAuthorWorker).not_to have_enqueued_sidekiq_job(params)
    end
  end
end
