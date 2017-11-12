class User < ActiveRecord::Base
  has_secure_password
  has_secure_token

  has_many :posts
  has_many :comments
  has_one :avatar
end
