#
# To mimic tweets by using fake_tweets.rb file
# Hopefully will write a RSpec test to automate this
#
require 'twitter'
require 'fake_tweets'

class TweetSample
  class << self 
    attr_reader :normal_tweet, 
                :retweet,
                :normal_tweet_w_media,
                :retweet_w_media,
                :normal_tweet_w_multiple_meida,
                :retweet_w_multiple_media,
                :quote_tweet,
                :quote_tweet_w_media,
                :quote_tweet_w_multiple_media
  end

  @normal_tweet          = Twitter::Tweet.new($normal_tweet_attrs)
  @normal_tweet_w_media  = Twitter::Tweet.new($normal_tweet_w_media_attrs)
  @normal_tweet_w_multiple_meida = 
    Twitter::Tweet.new($normal_tweet_w_multiple_media_attrs)

  @retweet               = Twitter::Tweet.new($retweet_attrs)
  @retweet_w_media       = Twitter::Tweet.new($retweet_w_media_attrs)
  @retweet_w_multiple_media = 
    Twitter::Tweet.new($retweet_w_multiple_media_attrs)
  #retweet_truncated  = Twitter::Tweet.new()

  @quote_tweet         = Twitter::Tweet.new($quote_tweet_attrs)
  @quote_tweet_w_media = Twitter::Tweet.new($quote_tweet_w_media_attrs)
  @quote_tweet_w_multiple_media = 
     Twitter::Tweet.new($quote_tweet_w_multiple_media_attrs)
end
