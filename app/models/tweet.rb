class Tweet < ApplicationRecord
  self.primary_key = :tweet_id

  belongs_to :user, foreign_key: :user_id, class_name: "TwitterUser"
  has_many :media, foreign_key: :tweet_id, dependent: :destroy

  validates :tweet_id, :user_id, :created_at, presence: true

  attr_accessor :tweet, :params

  def self.deleted_tweets
    Tweet.where("deleted = ? and text is not null", true)
      .order(deleted_at: :desc) || [NullTweet.new]
  end
  def self.update_deleted(tweet)
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

  def initialize tweet
    @tweet = tweet
    @params = if tweet.is_a? Hash
                tweet
              else
                parse_tweet @tweet
              end
    super @params
  end

  def media_info
    if @tweet.truncated?
      @tweet = Twitter::Tweet.new(@tweet.attrs[:extended_tweet].merge({id: tweet.id}))
    end
    @tweet.media
  end

  def parse_tweet tweet
    user = tweet.user
    params = {}

    params[:user_id]     = user.id
    params[:tweet_id]    = tweet.id
    params[:created_at]  = tweet.created_at
    params[:text]        = full_text
    params
  end

  def full_text
    if @tweet.truncated?
      @tweet.attrs[:extended_tweet][:full_text]
    else
      @tweet.full_text
    end
  end

  def retweet?
    !rt_id.nil?
  end

  def quote?
    !quoted_text.nil?
  end
end
