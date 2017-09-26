module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    user.update_attribute(:last_login, Time.now)
  end
  
  def current_user
		if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  def current_user?(user)
    current_user == user
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    forget(current_user)
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

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

	def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
	end
end
