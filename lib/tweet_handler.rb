require 'tweet_utils'

module TweetHandler
  extend TweetUtils

  class << self
    def on_delete(tweet)
      #msg = "Deleted tweet: UserID: #{tweet.user_id} - TweetID: #{tweet.id}"
      #puts msg

      Tweet.update_deleted(tweet)
    end

    def on_post(tweet)
      #msg  = "New Tweet! User: #{tweet.user.name}/#{tweet.user.screen_name} "
      #msg += "UserID: #{tweet.user.id} - TweetID: #{tweet.id}\n"
      #msg += "Tweeted at: #{tweet.created_at}\n"
      #msg += "#{tweet.attrs}\n"
      #puts msg

      process_tweet(tweet)
    end

    def on_stall_warning(warning)
      msg  = "Received A Stall Warning!\n"
      msg += "Code: #{warning.code}, Percentage full: #{warning.percent_full}\n"
      msg += "Message: #{warning.message}"
      puts msg

      # TODO: maybe send an e-mail? using delayed jobs?
    end

    def process_tweet(tweet)
      Tweet.save_tweet(get_args(tweet))
      
      media = get_media(tweet)
      Medium.save_media(media, tweet.id.to_s,
                       tweet.retweet? || tweet.quote? ) unless media.nil?
    end
  end # class << self

end # TweetHandler
