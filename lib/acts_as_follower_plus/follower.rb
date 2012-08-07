module ActsAsFollowerPlus #:nodoc:
  module Follower

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_follower_plus
        has_many :follows, :as => :follower, :dependent => :destroy
        include ActsAsFollowerPlus::Follower::InstanceMethods
        include ActsAsFollowerPlus::FollowerLib
      end
    end

    module InstanceMethods

      # Returns true if this instance is following the object passed as an argument.
      def following?(followable)
        0 < Follow.unblocked.approved.for_follower(self).for_followable(followable).count
      end

      # Returns the number of objects this instance is following.
      def follow_count
        Follow.unblocked.approved.for_follower(self).count
      end

      # Creates a new follow record for this instance to follow the passed object.
      # Does not allow duplicate records to be created.
      # If the followable object is private the follow record is flagged as pending.
      def follow(followable)
        if self != followable
          self.follows.find_or_create_by_followable_id_and_followable_type_and_pending(followable.id, parent_class_name(followable), !!followable.private? )
        end
      end

      # Deletes the follow record if it exists.
      def stop_following(followable)
        if follow = get_follow(followable)
          follow.destroy
        end
      end

      # Returns the follow records related to this instance by type.
      def follows_by_type(followable_type, options={})
        self.follows.unblocked.approved.includes(:followable).for_followable_type(followable_type).all(options)
      end

      # Returns the follow records related to this instance with the followable included.
      def all_follows(options={})
        self.follows.unblocked.approved.includes(:followable).all(options)
      end

      # Returns the pending follow records related to this instance by type.
      def follows_pending_by_type(followable_type, options={})
        self.follows.unblocked.pending.includes(:followable).for_followable_type(followable_type).all(options)
      end

      # Returns the pending follow records related to this instance with the followable included.
      def all_pending_follows(options={})
        self.follows.unblocked.pending.includes(:followable).all(options)
      end

      # Return the pending followables
      def all_pending_followables(options={})
        all_pending_follows(options).collect{ |f| f.followable }
      end

      # Returns the actual records which this instance is following.
      def all_following(options={})
        all_follows(options).collect{ |f| f.followable }
      end

      # Returns the actual records of a particular type which this record is following.
      def following_by_type(followable_type, options={})
        followables = followable_type.constantize.
          joins(:followings).
          where('follows.blocked'         => false,
                'follows.pending'         => false,
                'follows.follower_id'     => self.id, 
                'follows.follower_type'   => parent_class_name(self), 
                'follows.followable_type' => followable_type)
        if options.has_key?(:limit)
          followables = followables.limit(options[:limit])
        end
        if options.has_key?(:includes)
          followables = followables.includes(options[:includes])
        end
        followables
      end

      def following_by_type_count(followable_type)
        follows.unblocked.approved.for_followable_type(followable_type).count
      end

      # Allows magic names on following_by_type
      # e.g. following_users == following_by_type('User')
      # Allows magic names on following_by_type_count
      # e.g. following_users_count == following_by_type_count('User')
      def method_missing(m, *args)
        if m.to_s[/following_(.+)_count/]
          following_by_type_count($1.singularize.classify)
        elsif m.to_s[/following_(.+)/]
          following_by_type($1.singularize.classify)
        else
          super
        end
      end

      # Returns a follow record for the current instance and followable object.
      def get_follow(followable)
        self.follows.approved.unblocked.for_followable(followable).first
      end

    end

  end
end
