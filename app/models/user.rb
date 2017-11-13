class User < ActiveRecord::Base
  has_secure_password
  has_secure_token
  mount_uploader :avatar, AvatarUploader

  has_many :posts
  has_many :comments
end
