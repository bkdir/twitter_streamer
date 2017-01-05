module TwitterUsersHelper
  def bigger_image(url)
    url.gsub!("_normal", "_bigger")
  end

  def original_image(url)
    url.gsub!("_normal", "")
  end


  def deleted_tweet_count(user)
    Tweet.where({user_id: user[:id], deleted: true}).count
  end

  def recent_tweet_count(user)
    Tweet.where({user_id: user[:id]}).count
  end

  def last_tweeted_date_of(user)
    last_tweet = Tweet.where(user_id: user[:id]).order(:tweeted_at).last
    last_tweet.tweeted_at if last_tweet.present?
  end
end
