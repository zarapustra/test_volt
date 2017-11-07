class Report::ByAuthorWorker
  include Sidekiq::Worker

  def perform(params)
    Report::Command::GenerateReport.call(params) do
      on(:ok) do |file_name|
        Mailer.delay.send_file(params['email'], file_name, "tmp/#{file_name}")
      end
      on(:error) { |msg| logger.error msg }
    end
  end
end
