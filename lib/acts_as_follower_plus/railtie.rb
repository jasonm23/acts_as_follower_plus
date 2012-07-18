require 'acts_as_follower_plus'
require 'rails'

module ActsAsFollowerPlus
  class Railtie < Rails::Railtie

    initializer "acts_as_follower_plus.active_record" do |app|
      ActiveSupport.on_load :active_record do
        include ActsAsFollowerPlus::Follower
        include ActsAsFollowerPlus::Followable
      end
    end

  end
end
