class Quote < Tweet
  def parse_tweet tweet
    super.merge({
      rt_id: tweet.id.to_s, 
      quoted_text: quoted_text
    })
  end

  def media_info 
    tweet = @tweet.quoted_status
    if tweet.truncated?
      tweet = Twitter::Tweet.new(tweet.attrs[:extended_tweet].merge({id: tweet.id}))
    end
    tweet.media
  end

  def quoted_text
    tweet = @tweet.quoted_status
    tweet.truncated? ? tweet.attrs[:extended_tweet][:full_text] : tweet.full_text
  end
end
