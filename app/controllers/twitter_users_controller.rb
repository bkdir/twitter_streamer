require 'twitter_client'
require 'will_paginate/array'

# TODO: Consider storing users in db
class TwitterUsersController < ApplicationController

  def index
    @twitter_users = twitter_users_list
  end

  def show
    begin
      @user = parse_user_info(TwitterClient.client.user(params[:id].to_i))
    rescue Twitter::Error::NotFound => error
      Rails.logger.info "Unable to find user. Message: #{error.message}"
      flash[:danger] = "Unable to find user. UserID: params[:id]"
      redirect_to 'index'
      return
    end

    @deleted_tweets = Tweet.where(
      "user_id = ? and deleted = ? and text is not null", @user[:id], true)
    .order(deleted_at: :desc).paginate(page: params[:page], per_page: 20)
  end
  
  private
    def parse_user_info(user)
      parse_users_info([user]).first
    end

    def parse_users_info(users)
      result = []
      users.each do |user|
        h = {}
        h[:id]                = user.id
        h[:name]              = user.name
        h[:screen_name]       = user.screen_name
        h[:followers_count]   = user.followers_count
        h[:friends_count]     = user.friends_count
        h[:profile_image_url] = user.profile_image_url.to_s
        result << h
      end
      return result
    end

    def friend_ids_list_of(client)
      begin
        @friend_ids = client.friend_ids.to_a
      rescue Twitter::Error::TooManyRequests => error
        Rails.logger.info "Unable to get Twitter Users information '#{error.message}'"
        flash.now[:danger] = "Twitter Rate Limit Exceeded. Unable to retreive" +
                             "friends list at the moment."
      end

      @friend_ids || []
    end
    
    def set_friend_ids_to_session(id_array)
      session[:friend_ids] = id_array
      session[:friend_ids_count] = id_array.count
    end

    def twitter_users_list
      client = TwitterClient.client

      if (session[:friend_ids].blank? || 
          session[:friend_ids_count] != client.user.friends_count)
        set_friend_ids_to_session(friend_ids_list_of(client))
      end

      users = client.users(session[:friend_ids]).unshift(client.user)
      parsed_users = parse_users_info(users)
      parsed_users.paginate(page: params[:page], per_page: 30)
    end
end
