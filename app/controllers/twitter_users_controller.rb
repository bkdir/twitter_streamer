require 'twitter_client'
require 'will_paginate/array'

# TODO: Consider storing users in db
class TwitterUsersController < ApplicationController

  def index
    client = TwitterClient.client

    if ( session[:friend_ids].blank? || session[:friend_ids_count] != client.user.friends_count )
      friend_ids = client.friend_ids.to_a
      session[:friend_ids] = friend_ids
      session[:friend_ids_count] = friend_ids.count
    end

    users = parse_users_info(client.users(session[:friend_ids].to_a))
    @twitter_users = users.paginate(page: params[:page], per_page: 30)
  end

  def show
    # to test, show yourself only.
    @user = TwitterClient.client.user.attrs
  end
  
  private
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
end
