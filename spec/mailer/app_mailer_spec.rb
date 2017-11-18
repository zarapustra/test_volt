require 'rails_helper'

describe Mailer do
  to = 'test@example.com'
  
  describe 'when send with delay' do
    it 'can send with delay' do
      mail = Mailer.delay.send_file(to, 'mailer.txt', 'spec/support/mailer.txt')
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
    end
  end

  describe 'when send immediately' do
    let(:mail) { Mailer.send_file(to, 'mailer.txt', 'spec/support/mailer.txt') }

    it 'renders the headers' do
      expect(mail.subject).to eq('Report by author')
      expect(mail.to).to eq([to])
      expect(mail.from).to eq(['noreply@volt.com'])
    end

    it 'renders the file' do
      expect(mail.attachments.size).to eq(1)
      attachment = mail.attachments[0]
      expect(attachment.filename).to eq('mailer.txt')
    end

    it 'not delayed' do
      expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
    end
  end
end
