module Url
  def self.full_url(rel_url)
    return unless rel_url
    (Rails.env.production? ? Rails.application.secrets.domain : 'http://localhost:3000') + rel_url
  end
end
