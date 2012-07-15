class LevelsController < ApplicationController
  before_filter :require_get
  before_filter :require_current_user
  
  def show
    @level = Level.find(params[:id], :include => [:collection, {:game_pieces => :meta_data}])
    redirect_to root_path and return unless @level.collection.playable_by_user?(current_user)
    session[:current_level] = @level.id
  end
  
  def get_create_commands
    @level = Level.find(params[:id])
    render :layout => false
  end
  
end
