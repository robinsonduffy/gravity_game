class LevelElementsController < ApplicationController
  before_filter :require_login

  def unlock
    level_element = LevelElement.find(params[:id])
    json_response = Hash.new
    json_response["level_element"] = level_element
    if level_element.usable_by_user?(current_user)
      json_response["type"] = 'error'
      json_response["msg"] = 'Already Unlocked'
    elsif (level_element.coin_cost && level_element.coin_cost.value > current_user.coins)
      json_response["type"] = 'error'
      json_response["msg"] = 'Not Enough Coins'
    else
      current_user.remove_coins(level_element.coin_cost.value)
      current_user.coin_transactions.create!({:amount => 0 - level_element.coin_cost.value, :transaction_type => 'Unlock', :note => "Unlocked Game Piece: #{level_element.name.titlecase}"})
      level_element.unlocks.create!(:user => current_user)
      json_response["type"] = 'unlock'
      json_response["coin_cost"] = level_element.coin_cost.value
      json_response["user_coins"] = current_user.coins
    end


    render :json => json_response.to_json
  end
end
