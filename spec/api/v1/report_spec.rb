require 'rails_helper'
require 'sidekiq/testing'

describe 'GET /api/v1/reports/by_author' do
  url = '/api/v1/reports/by_author'

  before(:each) do
    sign_in!
  end
  it 'sends email with report when params are valid' do
    params = {
      start_date: Date.today.to_s,
      end_date: Date.tomorrow.to_s,
      email: 'reports@example.com'
    }
    get url, params, headers

    expect_status(200)
    expect(json['message']).to eq('Report generation started')
    expect(Report::ByAuthorWorker).to have_enqueued_sidekiq_job(params)
    Report::ByAuthorWorker.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
  end

  it 'renders errors when start_date is later than end_date' do
    params = {
      start_date: Date.tomorrow.to_s,
      end_date: Date.today.to_s,
      email: 'reports@example.com'
    }
    get url, params, headers
    expect_status(422)
    expect(json['errors']['dates']).to eq(['Start date is later than end date'])
  end

  it 'renders errors when email is empty' do
    params = {
      start_date: Date.today.to_s,
      end_date: Date.tomorrow.to_s,
      email: ''
    }
    get url, params, headers
    expect_status(422)
    expect(json['errors']['email']).to eq(['can\'t be blank'])
  end

  it 'renders errors when start_date is empty' do
    params = {
      start_date: '',
      end_date: Date.tomorrow.to_s,
      email: 'reports@example.com'
    }
    get url, params, headers
    expect_status(422)
    expect(json['errors']['start_date']).to eq(['can\'t be blank'])
  end

  it 'renders errors when start_date is empty' do
    params = {
      start_date: Date.today.to_s,
      end_date: '',
      email: 'reports@example.com'
    }
    get url, params, headers
    expect_status(422)
    expect(json['errors']['end_date']).to eq(['can\'t be blank'])
  end
end