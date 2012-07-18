class User < ActiveRecord::Base
  validates_presence_of :name
  acts_as_follower_plus
  acts_as_followable_plus
end
