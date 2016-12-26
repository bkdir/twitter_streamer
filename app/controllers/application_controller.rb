class ApplicationController < ActionController::Base
  before_action :login_required
  protect_from_forgery with: :exception
  include SessionsHelper

  def login_required
    unless logged_in?
      store_url
      flash[:danger] = "Please log in first"
      redirect_to login_path 
    end
  end
end
