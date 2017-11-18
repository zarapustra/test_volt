module RequestHelper
  include Rack::Test::Methods

  def json
    @json_response ||= JSON.parse(last_response.body, symbolize_names: true)
  end

  def renders_status(num)
    expect(last_response.status).to eq(num)
  end

  def headers(user)
    return nil unless user.present?
    @headers ||=
      {
        'Authenticate' => "Token #{token!(user)}"
      }
  end

  def token!(user)
    JsonWebToken.encode(user_id: user.id)
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end
