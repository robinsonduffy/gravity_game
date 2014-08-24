class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  before_filter :require_admin, :except => [:new, :create, :change_password, :change_password_post]
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
      @start_tag = "signup"
      flash.now[:error] = @user.errors.full_messages.join("<br/>").html_safe
      render "sessions/new"
    end
  end
  
  def index
    @users = User.all
    @title = "Users"
  end
  
  def edit
    @title = "Edit Account"
  end
  
  def update
    if @user.update_attributes(params[:user])
      @user.reload
      flash[:success] = "Updated Account"
      redirect_to edit_user_path(@user)
    else
      @title = "Edit Account"
      render :edit and return
    end
  end
  
  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = "User deleted (#{user.email})"
    redirect_to users_path
  end
  
  def change_password
    @title = "Change Password"
  end
  
  def change_password_post
    if User.authenticate(current_user.username, params[:current_password])
      new_attributes = {:password => params[:new_password], :password_confirmation => params[:new_password_confirmation]}
      if current_user.update_attributes(new_attributes)
        current_user.reload
        flash[:success] = "Password Changed"
        redirect_to root_path and return
      else
        flash[:error] = current_user.errors.full_messages.join("<br/>").html_safe
        redirect_to change_password_path and return
      end
    else
      flash[:error] = "Current Password was incorrect"
      redirect_to change_password_path and return
    end
  end
end
