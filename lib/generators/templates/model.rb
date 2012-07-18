class Follow < ActiveRecord::Base

  extend ActsAsFollowerPlus::FollowerLib
  extend ActsAsFollowerPlus::FollowScopes

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true

  def block!
    self.update_attribute(:blocked, true)
  end

end
