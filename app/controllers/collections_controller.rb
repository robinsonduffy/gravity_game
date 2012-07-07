class CollectionsController < ApplicationController
  before_filter :require_get
  before_filter :require_current_user
  
  def show
    @collection = Collection.find(params[:id])
  end
  
  def get_create_commands
    @collection = Collection.find(params[:id])
    render :layout => false
  end
end
