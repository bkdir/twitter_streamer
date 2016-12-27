class SessionsController < ApplicationController
  skip_before_action :login_required, :only => [:new, :create]

  def new
    # FIXME
    redirect_to twitter_users_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) || NullUser.new
    if user.authenticate(params[:session][:password])
      login(user)
      redirect_back_or(twitter_users_path)
    else
      flash.now[:danger] = "Invalid username/password combination"
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
