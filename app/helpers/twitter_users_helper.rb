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
    last_tweet = Tweet.where(user_id: user[:id]) .order(:created_at).last
    if last_tweet.present?
      "#{last_tweet.created_at.to_formatted_s(:db)} #{last_tweet.created_at.zone}"
    end
  end
end
