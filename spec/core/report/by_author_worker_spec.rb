require 'rails_helper'
require 'sidekiq/testing'

describe Report::ByAuthorWorker do
  let(:params) do
    {
      start_date: Date.today.to_s,
      end_date: Date.tomorrow.to_s,
      email: 'reports@example.com'
    }
  end

  context 'when perform async' do
    before { Report::ByAuthorWorker.perform_async(params) }

    it 'enqueues worker' do
      expect(Report::ByAuthorWorker).to have_enqueued_sidekiq_job(params)
    end
    it 'enqueues mailer job' do
      Report::ByAuthorWorker.drain
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
    end
  end

  context 'when perform immediately' do
    before { subject.perform(params) }

    it 'doesn\'t enqueues worker' do
      expect(Report::ByAuthorWorker).not_to have_enqueued_sidekiq_job(params)
    end
    it 'enqueues mailer job' do
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
    end
  end
end
