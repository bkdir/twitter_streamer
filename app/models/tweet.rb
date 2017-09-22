class Tweet < ApplicationRecord
  self.primary_key = :tweet_id

  belongs_to :user, foreign_key: :user_id, class_name: "TwitterUser"
  has_many :media, foreign_key: :tweet_id, dependent: :destroy

  validates :tweet_id, :user_id, :created_at, presence: true

  def is_retweet?
    !rt_id.nil?
  end

  def is_quote?
    !quoted_text.nil?
  end

  class << self
    def deleted_tweets
      Tweet.where("deleted = ? and text is not null", true)
        .order(deleted_at: :desc) || [NullTweet.new]
    end

    def update_deleted(tweet)
      begin
        orig_tweet = Tweet.find_by(tweet_id: tweet.id)
        if orig_tweet
          orig_tweet.update({deleted: true, deleted_at: Time.now})
        else
          # maybe an old one, we just don't have it. Save for the record.
          Tweet.create!(tweet_id: tweet.id, 
                        user_id: tweet.user_id,
                        deleted: true, 
                        deleted_at: Time.now,
                        created_at: Time.now)
        end
      rescue ActiveRecord::ActiveRecordError => e
        logger.fatal "Failed to update tweet<#{tweet.id}> as Deleted!" +
          "\nMessage: #{e.message}"
      end
    end

    def save_tweet(my_attrs)
      begin
        tweet = Tweet.new(my_attrs)
      rescue ActiveModel::ForbiddenAttributesError => e
        logger.fatal "Failed to initialize a tweet object with given " + 
          "attributes: #{my_attrs}\nMessage: #{e.message}"
      end

      begin
        tweet.save!
      rescue ActiveRecord::ActiveRecordError => e
        logger.fatal "Failed to save the Tweet: #{tweet.inspect}\n" + 
          "Message: #{e.message}"
      end
    end
  end # class << self
end
