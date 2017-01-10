module SessionsHelper

  def login(user)
    session[:user_id] = user.id
    user.update_attribute(:last_login, Time.now)
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user?(user)
    current_user == user
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def store_url
    session[:requested_url] = request.original_url if request.get?
  end

  def redirect_back_or(default_url)
    redirect_to(session[:requested_url] || default_url)
    session.delete(:requested_url)
  end
end
