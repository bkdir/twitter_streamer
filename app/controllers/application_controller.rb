class ApplicationController < ActionController::Base
  before_filter :login_required
  protect_from_forgery with: :exception
  include SessionsHelper

  def login_required
    redirect_to root_path if !logged_in?
  end
end
