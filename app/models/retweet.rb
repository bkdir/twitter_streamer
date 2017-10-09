class Retweet < Tweet
  def parse_tweet(tweet)
    super.merge(rt_id: tweet.id.to_s)
  end

  def media_info
    tweet = @tweet.retweeted_status
    if tweet.truncated?
      tweet = Twitter::Tweet.new(tweet.attrs[:extended_tweet].merge({id: tweet.id}))
    end
    tweet.media
  end

  def full_text
    if @tweet.truncated? 
      @tweet.attrs[:extended_tweet][:full_text]
    else
      tweet = @tweet.retweeted_status
      "RT @#{tweet.user.screen_name} #{tweet.full_text}"
    end
  end
end
