class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  before_filter :require_admin, :except => [:new, :create, :edit]
  before_filter :require_guest, :only => [:new, :create]
  
  def new
    @title = "Sign Up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      auto_login(@user)
      flash[:success] = "Thanks for signing up."
      redirect_to root_path
    else
      @title = "Sign Up"
      render :new
    end
  end
  
  def index
    @users = User.all
    @title = "Users"
  end
  
  def edit
    @title = "Edit Account"
    @user = User.find(params[:id])
    render_403 unless current_user == @user
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      @user.reload
      flash[:success] = "Updated User (#{@user.email})"
      redirect_to users_path
    else
      @title = "Edit User"
      render :edit
    end
  end
  
  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = "User deleted (#{user.email})"
    redirect_to users_path
  end
end
