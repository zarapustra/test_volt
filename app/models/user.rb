class User < ActiveRecord::Base
  has_secure_password
  has_secure_token

  has_many :posts
  has_many :comments
  #has_one :user_stat, class_name: 'UserStat'
  #delegate :posts_count, :comments_count, to: :user_stat
end
