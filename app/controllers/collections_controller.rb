class CollectionsController < ApplicationController
  before_filter :require_get
  before_filter :require_current_user
  
  def show
    @collection = Collection.find(params[:id])
  end
end
