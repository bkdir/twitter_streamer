require 'tweet_utils'

# TODO: refactor process_*
module TweetHandler
  extend TweetUtils
  class << self

    def on_delete(tweet)
      msg = "Deleted tweet: UserID: #{tweet.user_id} - TweetID: #{tweet.id}"
      Rails.logger.info(msg)

      Tweet.update_deleted(tweet)
    end

    def on_post(tweet)
      msg  = "New Tweet: User: #{tweet.user.name}/#{tweet.user.screen_name}\n"
      msg += "UserID: #{tweet.user.id} - TweetID: #{tweet.id}\n"
      msg += "Tweet: #{tweet.full_text}\n"
      msg += "Tweeted at: #{tweet.created_at}\n"
      msg += "#{tweet.attrs}\n"
      #Rails.logger.info(msg)

      process_tweet(tweet)
    end

    def on_stall_warning(warning)
      msg  = "Received A Stall Warning!\n"
      msg += "Code: #{warning.code}, Percentage full: #{warning.percent_full}\n"
      msg += "Message: #{warning.message}"
      Rails.logger.info(msg)

      # TODO: maybe send an e-mail? using delayed jobs?
    end

    def process_tweet(tweet)
      if tweet.retweet?
        process_retweet(tweet)
      elsif tweet.quote?
        process_quote(tweet)
      else
        process_normal(tweet)
      end
    end

    def process_normal(tweet)
      args  = get_args(tweet)
      Tweet.save_tweet(args)
      
      media = get_media(tweet)
      Medium.save_media(media, tweet.id.to_s, tweet.user.id.to_s) unless media.nil?
    end

    def process_quote(tweet)
      args  = get_args(tweet)
      qt = tweet.quoted_status
      args[:rt_id] = qt.id.to_s
      args[:quoted_text] = get_text(qt)

      Tweet.save_tweet(args)
      media = get_media(qt)
      Medium.save_media(media, qt.id.to_s, qt.user.id.to_s, true) unless media.nil?
    end

    def process_retweet(tweet)
      args  = get_args(tweet)
      retweet = tweet.retweeted_status
      args[:rt_id] = retweet.id.to_s

      Tweet.save_tweet(args)

      media = get_media(retweet)
      Medium.save_media(media, retweet.id.to_s, 
                        retweet.user.id.to_s, true) unless media.nil?
    end

  end # class << self
end # TweetHandler
