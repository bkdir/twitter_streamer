module TweetUtils

  def get_args(tweet)
    h = {}
    user = tweet.user

    h[:user_id]     = user.id.to_s
    h[:tweet_id]    = tweet.id.to_s
    h[:screen_name] = user.screen_name
    h[:name]        = user.name 
    h[:tweeted_at]  = tweet.created_at
    h[:text] = get_text(tweet)
    Rails.logger.info("bkdir: get_args returns #{h.inspect}")
    return h
  end

  def get_media(tweet)
    if tweet.truncated?
      extended_tweet = Twitter::Tweet.new( 
        tweet.attrs[:extended_tweet].merge({id: tweet.id}))
      return extended_tweet.media if extended_tweet.media?
    end
    
    return tweet.media? ? tweet.media : nil
  end

  def get_retweet_text(tweet)
    text = "RT @#{tweet.user.screen_name}"
    return tweet.truncated? ? "#{text} #{get_text(tweet)}" : "#{text} #{tweet.full_text}"
  end
  
  def get_text(tweet)
    return tweet.attrs[:extended_tweet][:full_text] if tweet.truncated?
    return get_retweet_text(tweet.retweeted_status) if tweet.retweet? 
    return tweet.full_text
  end

end
