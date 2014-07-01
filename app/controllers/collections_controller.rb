class CollectionsController < ApplicationController
  before_filter :require_login
  
  def show
    @collection = Collection.find(params[:id])
    redirect_to root_path(:lc => @collection.number) and return if((@collection.coin_cost && @collection.coin_cost.value > current_user.coins) && !@collection.playable_by_user?(current_user))
  end
  
  def unlock
    @collection = Collection.find(params[:id])
    redirect_to collection_path(@collection) and return if @collection.playable_by_user?(current_user)
    redirect_to root_path(:lc => @collection.number) and return if (@collection.coin_cost && @collection.coin_cost.value > current_user.coins)
    @collection.unlocks.create!(:user => current_user)
    current_user.remove_coins(@collection.coin_cost.value)
    current_user.coin_transactions.create!({:amount => 0 - @collection.coin_cost.value, :transaction_type => 'Unlock', :note => "Unlocked Collection: #{@collection.name}"})
    redirect_to collection_path(:id => @collection.id, :cdisp => "-#{@collection.coin_cost.value}")
  end
  
  def get_create_commands
    @collection = Collection.find(params[:id])
    render :layout => false
  end
end
