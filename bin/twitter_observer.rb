#!/usr/bin/env ruby

require 'twitter'
require 'tweet_handler'

$streamer = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = Rails.application.secrets.twitter_consumer_key
  config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
  config.access_token        = Rails.application.secrets.twitter_access_token
  config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
end

def observe_twitter
  $streamer.user do |object|
    case object
    when Twitter::Tweet
      TweetHandler.on_post(object)
    when Twitter::Streaming::DeletedTweet
      TweetHandler.on_delete(object)
    when Twitter::Streaming::StallWarning
      TweetHandler.on_stall_warning(object)
    end
  end
end

# start streaming
observe_twitter
