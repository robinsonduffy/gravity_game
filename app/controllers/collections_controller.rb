class CollectionsController < ApplicationController
  before_filter :require_get, :except => [:unlock]
  before_filter :require_current_user
  
  def show
    @collection = Collection.find(params[:id])
  end
  
  def unlock
    @collection = Collection.find(params[:id])
    redirect_to collection_path(@collection) and return if @collection.playable_by_user?(current_user)
    redirect_to root_path(:lc => @collection.number) and return if @collection.coin_cost > current_user.coins
    @collection.unlocks.create!(:user => current_user)
    current_user.remove_coins(@collection.coin_cost)
    redirect_to collection_path(:id => @collection.id, :coin_display => "-#{@collection.coin_cost}")
  end
  
  def get_create_commands
    @collection = Collection.find(params[:id])
    render :layout => false
  end
end
