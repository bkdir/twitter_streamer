class Tweet < ApplicationRecord
  # TODO: Add Media support
  validates :tweet_id, presence: :true
  validates :user_id, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true

  class << self
    def save(tweet)
      my_attrs = parse_attributes(tweet.attrs)

      begin
        tweet = Tweet.new(my_attrs)
      rescue ActiveModel::ForbiddenAttributesError => exception
        logger.fatal "Failed to initialize a tweet object with the given attributes: #{my_attrs}"
        logger.fatal "Message: #{exception.message}"
      end

      if (!tweet.valid?)
        # TODO: do something
        logger.info "Tweet is not valid! #{tweet.inspect}"
      end

      begin
        tweet.save!
      rescue ActiveRecord::ActiveRecordError => exception
        # TODO: do something
        logger.fatal "Failed to save the Tweet: #{tweet.inspect}"
        logger.fatal "Message: #{exception.message}"
      end
    end

    def update_deleted(tweet)
      begin
        # saving tweet ids as strings since Twitter's ids are huuge
        saved_tweet = Tweet.find_by(tweet_id: tweet.attrs[:id_str])
        if saved_tweet
          saved_tweet.update({ deleted: true, deleted_at: Time.now })
        else
          # maybe an old one, we just don't have it.. Save with a placeholder.
          Tweet.create!(tweet_id: tweet.attrs[:id_str], user_id: tweet.attrs[:user_id_str],
                        text: "--- No Tweet Info. Possibly an old tweet has been deleted ---",
                        deleted: true, deleted_at: Time.now, tweeted_at: Time.now)
        end
      rescue ActiveRecord::ActiveRecordError => exception
        # TODO: send -mail, maybe
        logger.fatal "Unable to update the tweet<#{tweet.id}> as Deleted!"
        logger.fatal "Message: #{exception.message}"
      end
    end

    def deleted_tweets
      Tweet.where({deleted: true}).order(deleted_at: :desc) || [NullTweet.new]
    end

    def parse_attributes(attrs)
      h = {}
      if !attrs.is_a? Hash || attrs.empty?
         # TODO: log something
         logger.fatal "Parse attributes returning an empty Hash! attrs: #{attrs.inspect}"
         return h
      end

      h[:user_id]     = attrs.fetch(:user, {}).fetch(:id_str, nil)
      h[:tweet_id]    = attrs[:id_str]
      h[:screen_name] = attrs.fetch(:user, {}).fetch(:screen_name, nil)
      h[:name] = attrs.fetch(:user, {}).fetch(:name, nil)
      h[:text]        = attrs[:text]
      h[:tweeted_at]  = attrs[:created_at]

      # additional stuff  :id=>813954516479578113
      #  If you retweeted something, original text of that tweet is here: 
      #h[:text] = attrs[:quoted_status][:extended_tweet][:full_text]
      # all the media info is under:
      # entities[:media] yada extended_entities[:media]
      # sanirim sadece retweet edersen => retweeted_status eger yazi da yazarsan quoted_status
      # quoted_status un de user i var. full_text sadece burada var.
      # retweeted_status un de user ve text i var. NEyi retweet ettiysen o user ise kimi retweet ettigin
      return h
    end
  end
end
