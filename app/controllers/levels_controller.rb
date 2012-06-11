class LevelsController < ApplicationController
  before_filter :require_get
  before_filter :require_current_user
  
  def show
    @level = Level.find(params[:id])
  end
end
