class UserNotation < ActiveRecord::Base
  belongs_to :user_account

  validates_presence_of :notation
  validates_uniqueness_of :notation

end

