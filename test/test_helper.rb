ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  def login_test_user(user, password: 'password')
    post login_path, params: {
      session: {
        name: user.name,
        password: password 
      }
    }
  end
end
