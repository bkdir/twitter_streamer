class Tweet < ApplicationRecord
  # TODO: Add Media support
  validates :tweet_id, presence: :true
  validates :user_id, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true

  class << self
    def save(tweet)
      my_attrs = parse_attributes(tweet.attrs)
      begin
        tweet = Tweet.new(my_attrs)
      rescue ActiveModel::ForbiddenAttributesError => exception
        logger.fatal "Failed to initialize a tweet object with the given attributes: #{my_attrs}"
        logger.fatal "Message: #{exception.message}"
      end

      if (!tweet.valid?)
        # TODO: do something
        logger.info "Tweet is not valid! #{tweet.inspect}"
      end

      begin
        tweet.save!
      rescue ActiveRecord::ActiveRecordError => exception
        # TODO: do something
        logger.fatal "Failed to save the Tweet: #{tweet.inspect}"
        logger.fatal "Message: #{exception.message}"
      end
    end

    def update_deleted(tweet)
      begin
        Tweet.find_by(tweet_id: tweet.id).update({
          deleted: true,
          deleted_at: Time.now
        })
      rescue ActiveRecord::ActiveRecordError => exception
        # TODO: send -mail, maybe
        logger.fatal "Unable to update the tweet<#{tweet.id}> as Deleted!"
        logger.fatal "Message: #{exception.message}"
      end
    end

    def deleted_tweets
      Tweet.where("deleted = ?", true).order(deleted_at: :desc) || NullTweet.new
    end

    def parse_attributes(attrs)
      h = {}
      if !attrs.is_a? Hash || attrs.empty?
         # TODO: log something
         logger.fatal "Parse attributes returning an empty Hash! attrs: #{attrs.inspect}"
         return h
      end

      h[:user_id]     = attrs.fetch(:user, {}).fetch(:id, nil)
      h[:tweet_id]    = attrs[:id]
      h[:screen_name] = attrs.fetch(:user, {}).fetch(:screen_name, nil)
      h[:text]        = attrs[:text]
      h[:tweeted_at]  = attrs[:created_at]
      return h
    end
  end
end
