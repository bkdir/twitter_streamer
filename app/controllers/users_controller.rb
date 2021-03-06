class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end
  
  def index
    @users = User.order(updated_at: :desc)
      .paginate(page: params[:page], per_page: 30) || [NullUser.new]
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

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile has been updated"
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted."
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      # Admin can edit anyone, for now.
      @user = User.find(params[:id])
      redirect_to users_path if (!current_user?(@user) && !current_user.admin)
    end

    def admin_user
      redirect_to(users_url) unless current_user.admin?
    end
end
