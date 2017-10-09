module TweetHandler
  module_function

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

    TwitterUser.find_or_save_user(tweet.user)
    process_tweet(tweet)
  end

  def on_stall_warning(warning)
    msg  = "Received A Stall Warning!\n"
    msg += "Code: #{warning.code}, Percentage full: #{warning.percent_full}\n"
    msg += "Message: #{warning.message}"
    logger.info msg
  end

  def process_tweet(tweet)
    tweet = 
      if tweet.retweet?
        Retweet.new(tweet)
      elsif tweet.quote?
        Quote.new(tweet)
      else
        Tweet.new(tweet)
      end
    tweet.save

    media = tweet.media_info
    unless media.nil?
       Medium.save_media(media, tweet.id.to_s, tweet.retweet? || tweet.quote? )
    end
  end
end
