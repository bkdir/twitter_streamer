require 'tweet_handler'
require 'tweet_sample'

# Run test for each instance variable of TweetSample class
i = 0
TweetSample.instance_variables.each do |iv|
  i += 1
  #next if i <= 8
  puts "---- #{iv.to_s} ----"
  TweetHandler.on_post(TweetSample.instance_variable_get(iv))
  #break
end
