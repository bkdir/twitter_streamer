class Tweet < ApplicationRecord
  self.primary_key = :tweet_id

  belongs_to :user, foreign_key: :user_id, class_name: "TwitterUser"
  has_many :media, foreign_key: :tweet_id, dependent: :destroy

  validates :tweet_id, :user_id, :created_at, presence: true

  attr_accessor :tweet, :params

  def self.deleted_tweets
    # TODO: indexing
    Tweet.where("deleted = ? and text is not null", true)
      .order(deleted_at: :desc) || [NullTweet.new]
  end

  def self.update_deleted(tweet)
    orig_tweet = Tweet.find(tweet.id)
    orig_tweet.update(deleted: true, deleted_at: Time.now)
  rescue ActiveRecord::RecordNotFound 
    # maybe an old one, we just don't have it. Save for the record/statistics
    Tweet.create!(tweet_id: tweet.id, 
                  user_id: tweet.user_id,
                  deleted: true, 
                  deleted_at: Time.now,
                  created_at: Time.now)
  end

  def initialize(tweet)
    @tweet = tweet
    @params = if tweet.is_a? Hash
                @tweet
              else
                parse_tweet @tweet
              end
    super @params
  end

  def media_info
    if @tweet.truncated?
      Twitter::Tweet.new(@tweet.attrs[:extended_tweet].merge(id: tweet.id)).media
    else
      @tweet.media
    end
  end

  def parse_tweet(tweet)
    {
      user_id: tweet.user.id,
      tweet_id: tweet.id,
      created_at: tweet.created_at,
      text: full_text
    }
  end

  def full_text
    @tweet.truncated? ? @tweet.attrs[:extended_tweet][:full_text] : @tweet.full_text
  end

  def retweet?
    self.is_a?(Retweet)
  end

  def quote?
    self.is_a?( Quote)
  end
end
