class LevelsController < ApplicationController
  before_filter :require_get
  before_filter :require_current_user
  
  def show
    @level = Level.find(params[:id])
    session[:current_level] = @level.id
  end
  
  def get_create_commands
    @level = Level.find(params[:id])
    render :layout => false
  end
  
end
