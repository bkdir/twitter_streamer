class Tweet < ApplicationRecord
  has_many :media, 
           foreign_key: :tweet_id, 
           primary_key: :tweet_id

  validates :tweet_id,   presence: :true
  validates :user_id,    presence: true
  validates :tweeted_at, presence: true

  def is_retweet?
    !rt_id.nil?
  end

  def is_quote?
    !quoted_text.nil?
  end

  class << self

    def deleted_tweets
      Tweet.where("deleted = ? and text is not null", true).order(deleted_at: :desc) || [NullTweet.new]
    end

    def update_deleted(tweet)
      begin
        # saving tweet ids as strings since Twitter's ids are huuge
        saved_tweet = Tweet.find_by(tweet_id: tweet.attrs[:id_str])
        if saved_tweet
          saved_tweet.update({ deleted: true, deleted_at: Time.now })
        else
          # maybe an old one, we just don't have it. Save for the record
          Tweet.create!(tweet_id: tweet.attrs[:id_str], 
                        user_id: tweet.attrs[:user_id_str],
                        deleted: true, 
                        deleted_at: Time.now, 
                        tweeted_at: Time.now)
        end
      rescue ActiveRecord::ActiveRecordError => exception
        # TODO: send e-mail, maybe
        logger.fatal "Unable to update the tweet<#{tweet.id}> as Deleted!"
        logger.fatal "Message: #{exception.message}"
      end
    end

    def save_tweet(my_attrs)
      begin
        tweet = Tweet.new(my_attrs)
      rescue ActiveModel::ForbiddenAttributesError => exception
        logger.fatal "Failed to initialize a tweet object with 
          given attributes: #{my_attrs}"
        logger.fatal "Message: #{exception.message}"
      end

      begin
        tweet.save!
      rescue ActiveRecord::ActiveRecordError => exception
        logger.fatal "Failed to save the Tweet: #{tweet.inspect}"
        logger.fatal "Message: #{exception.message}"
      end
    end

  end # class << self
end
