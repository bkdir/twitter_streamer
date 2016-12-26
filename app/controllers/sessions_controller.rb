class SessionsController < ApplicationController
  skip_before_action :login_required, :only => [:new, :create]
  # TODO: users_path should actually be twitter->following page
  #
  def new
    # FIXME
    redirect_to users_path if logged_in?
  end

  def create
    user = User.find_by(name: params[:session][:name].downcase) || NullUser.new
    if user.authenticate(params[:session][:password])
      login(user)
      redirect_back_or(users_path)
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
