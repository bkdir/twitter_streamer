require 'test_helper'
require 'tweet_handler'
require 'twitter'
require 'support/fake_tweets'

class TweetHandlerTest < ActiveSupport::TestCase
  test "on post, should save 'tweet'" do
    @tweet = Twitter::Tweet.new($tweet)
    assert_difference('Tweet.count', 1) do
      TweetHandler.on_post(@tweet)
    end
  end

  test "on post, should save 'tweet' and 'media'" do
    @tweet = Twitter::Tweet.new($tweet_w_media)
    assert_difference ['Tweet.count', 'Medium.count'], 1 do
      TweetHandler.on_post(@tweet)
    end
  end

  # FIXME: merge w the previous test
  test "on post, should save 'tweet' with multiple 'media'" do
    @tweet = Twitter::Tweet.new($tweet_w_multiple_media)
    assert_difference("Tweet.count", 1) do
      assert_difference("Medium.count", 2) do
        TweetHandler.on_post(@tweet)
      end
    end
  end

  test "on post, should save 'retweet'" do
    @retweet = Twitter::Tweet.new($retweet)
    assert_difference('Tweet.count', 1) do
      TweetHandler.on_post(@retweet)
    end
    assert Tweet.last.rt_id 
  end

  test "on post, should save 'retweet' and 'media'" do
    @retweet = Twitter::Tweet.new($retweet_w_media)
    assert_difference ['Tweet.count', 'Medium.count'], 1 do
      TweetHandler.on_post(@retweet)
    end
    assert Tweet.last.rt_id 
  end

  test "on post, should save 'retweet' with multiple 'media'" do
    @retweet = Twitter::Tweet.new($retweet_w_multiple_media)
    assert_difference("Tweet.count", 1) do
      assert_difference("Medium.count", 2) do
        TweetHandler.on_post(@retweet)
      end
    end
    assert Tweet.last.rt_id 
  end

  test "on post, should save 'quote'" do
    @quote = Twitter::Tweet.new($quote)
    assert_difference('Tweet.count', 1) do
      TweetHandler.on_post(@quote)
    end
    assert Tweet.last.quoted_text
  end

  test "on post, should save 'quote' and 'media'" do
    @quote = Twitter::Tweet.new($quote_w_media)
    assert_difference ['Tweet.count', 'Medium.count'], 1 do
      TweetHandler.on_post(@quote)
    end
    assert Tweet.last.quoted_text
  end

  test "on post, should save 'quote' with multiple 'media'" do
    @quote = Twitter::Tweet.new($quote_w_multiple_media)
    assert_difference("Tweet.count", 1) do
      assert_difference("Medium.count", 2) do
        TweetHandler.on_post(@quote)
      end
    end
    assert Tweet.last.quoted_text
  end

  test "on delete, existing tweets should be marked as deleted" do
    # insert the tweet that will be deleted first.
    @tweet = Twitter::Tweet.new($tweet)
    TweetHandler.on_post(@tweet)
    new_tweet = Tweet.last

    @tweet = Twitter::Streaming::DeletedTweet.new($tweet)
    TweetHandler.on_delete(@tweet)
    assert_not new_tweet.deleted
    assert new_tweet.reload.deleted
  end

  test "on delete, if deleted tweet doesn't exist then new tweet should be created as deleted" do
    @tweet = Twitter::Streaming::DeletedTweet.new($deleted_tweet)

    assert_difference('Tweet.count', 1) do
      TweetHandler.on_delete(@tweet)
    end
    assert Tweet.last.deleted
  end
end
