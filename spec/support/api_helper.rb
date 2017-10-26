module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def json
    JSON.parse(last_response.body)
  end

  def status
    last_response.status
  end

  def expect_200
    expect(status).to eql(200)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request #apply to all spec for apis folder
end
