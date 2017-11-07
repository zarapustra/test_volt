class UserStat < ActiveRecord::Base
  self.primary_key = 'user_id'

  #belongs_to :user, inverse_of: :user_stat
end