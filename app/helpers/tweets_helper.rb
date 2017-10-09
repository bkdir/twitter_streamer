require 'twitter_client'

module TweetsHelper

  # only if the original tweet is not the source
  def get_tweet_source(tweet)
    return nil unless tweet.retweet?

    begin
      client ||= TwitterClient.client
      client.status(original_id(tweet)).url.to_s
    rescue Twitter::Error::NotFound 
      nil
    end
  end

  private
    def original_id(tweet)
      tweet.retweet? ? tweet.rt_id : tweet.tweet_id
    end

end
