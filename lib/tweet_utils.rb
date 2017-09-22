module TweetUtils

  def get_args(tweet)
    puts "get_args"
    args = get_common_args(tweet)
    if tweet.retweet?
      args.merge!(get_retweet_args(tweet.retweeted_status))
    elsif tweet.quote?
      args.merge!(get_quote_args(tweet.quoted_status))
    end
    Rails.logger.info("bkdir: get_args returns #{args.inspect}")
    return args
  end


  def get_common_args(tweet)
    h = {}
    user = tweet.user

    h[:user_id]     = user.id
    h[:tweet_id]    = tweet.id
    h[:created_at]  = tweet.created_at
    h[:text]        = get_text(tweet)
    return h
  end

  def get_quote_args(tweet)
    { rt_id: tweet.id.to_s, quoted_text: get_text(tweet) }
  end

  def get_retweet_args(tweet)
    { rt_id: tweet.id.to_s }
  end

  def get_media(tweet)
    tweet = tweet.retweet?   ?
      tweet.retweeted_status :
      (tweet.quote? ? tweet.quoted_status : tweet)

    if tweet.truncated?
      extended_tweet = Twitter::Tweet.new( 
        tweet.attrs[:extended_tweet].merge({id: tweet.id}))
      return extended_tweet.media if extended_tweet.media?
    end
    
    return tweet.media? ? tweet.media : nil
  end

  def get_text(tweet)
    return tweet.attrs[:extended_tweet][:full_text] if tweet.truncated?
    return get_retweet_text(tweet.retweeted_status) if tweet.retweet? 
    return tweet.full_text
  end

  def get_retweet_text(tweet)
    text = "RT @#{tweet.user.screen_name}"
    return tweet.truncated? ? "#{text} #{get_text(tweet)}" : "#{text} #{tweet.full_text}"
  end
  

end
