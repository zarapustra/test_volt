module Url
  def self.full_url(rel_url)
    (Rails.env.production? ? Rails.application.secrets.domain : 'http://localhost:4000') + rel_url
  end
end
