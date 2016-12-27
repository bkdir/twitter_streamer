class TweetsController < ApplicationController
  def delete
  end

  def index
    @tweets = Tweet.deleted_tweets.paginate(page: params[:page], per_page: 30)
  end
end
