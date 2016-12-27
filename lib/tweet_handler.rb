class TweetHandler

  class << self
    def on_delete(tweet)
      msg = "A Tweet Has Been Deleted by UserID: #{tweet.user_id} - TweetID: #{tweet.id}"
      msg += "Object: #{tweet.attrs}"
      Rails.logger.info(msg)

      Tweet.update_deleted(tweet)
    end

    def on_post(tweet)
      msg  = "A New Tweet Has Been Posted by User: #{tweet.user.name}/#{tweet.user.screen_name}\n"
      msg += "UserID: #{tweet.user.id}, TweetID: #{tweet.id}\n"
      msg += "Tweet: #{tweet.full_text}\n"
      msg += "Tweeted at: #{tweet.created_at}\n"
      msg += "#{tweet.attrs}\n"
      Rails.logger.info(msg)

      Tweet.save(tweet)
    end

    def on_stall_warning(warning)
      msg  = "Received A Stall Warning!\n"
      msg += "Code: #{warning.code}, Message: #{warning.message}, Percentage full: #{warning.percent_full}"
      Rails.logger.info(msg)

      # TODO: maybe send an e-mail? using delayed jobs?
    end
  end

end
