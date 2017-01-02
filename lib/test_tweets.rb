require 'tweet_handler'
require 'tweet_sample'

# Run test for each instance variable of TweetSample class
TweetSample.instance_variables.each do |iv|
  TweetHandler.on_post(TweetSample.instance_variable_get(iv))
end
