require "acts_as_follower_plus/version"

module ActsAsFollowerPlus
  autoload :Follower,     'acts_as_follower_plus/follower'
  autoload :Followable,   'acts_as_follower_plus/followable'
  autoload :FollowerLib,  'acts_as_follower_plus/follower_lib'
  autoload :FollowScopes, 'acts_as_follower_plus/follow_scopes'

  require 'acts_as_follower_plus/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end
