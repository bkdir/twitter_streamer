class UsersController < ApplicationController
  #TODO: most recently added user should be on top
  #
  def new
    @user = User.new
  end
  
  def index
    @users = User.all || [NullUser.new]
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User #{@user.name} has been added"
      redirect_to users_path
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
