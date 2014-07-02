class UsersController < ApplicationController
  before_filter :require_login, :except => [:new]
  before_filter :require_admin, :except => [:new]
  before_filter :require_guest, :only => [:new]
  
  def new
    @title = "Sign Up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Created User (#{@user.email})"
      redirect_to users_path
    else
      @title = "Create New User"
      render :new
    end
  end
  
  def index
    @users = User.all
    @title = "Users"
  end
  
  def edit
    @title = "Edit User"
    @user = User.find(params[:id])
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
