class AjaxController < ApplicationController
  before_filter :require_login, :only => [:complete_level]
  
  def complete_level
    level = Level.find_by_id(session[:current_level])
    ajax_response({:type => 'Error', :code => 'CL2'}) and return if level.nil?
    render :nothing => true, :status => 403 and return unless level.collection.playable_by_user?(current_user)
    rotations = params[:r].to_i || 0
    ajax_response({:type => 'Error', :code => 'CL4'}) and return if rotations < 1
    weighted_rotations = params[:w].to_i || 0
    ajax_response({:type => 'Error', :code => 'CL7'}) and return if weighted_rotations < 1
    ajax_response({:type => 'Error', :code => 'CL8'}) and return if weighted_rotations < rotations
    locks = params[:l].to_i || -1
    ajax_response({:type => 'Error', :code => 'CL5'}) and return if locks < 0
    coins = params[:c].to_i || -1
    ajax_response({:type => 'Error', :code => 'CL6'}) and return if coins < 0
    time_taken = params[:t].to_i || 0
    ajax_response({:type => 'Error', :code => 'CL9'}) and return if time_taken < 1
    if current_user.completed_levels.include?(level)
      #this user has already completed this level
      completion = current_user.completions.find_by_level_id(level)
      response = {:type => 'Success', :first_time => 'false'}
      response[:add_coins] = 0
    else
      #this is the first time this user has completed this level
      completion = current_user.completions.build({:level => level})
      response = {:type => 'Success', :first_time => 'true'}
      current_user.add_coins(10)
      response[:add_coins] = 10
    end
    #ROTATIONS
    u_rotations = completion.meta_data.find_by_key("rotations") || completion.meta_data.build(:key => 'rotations', :value => rotations)
    #LOCKS
    u_locks = completion.meta_data.find_by_key("locks") || completion.meta_data.build(:key => 'locks', :value => locks)
    #COINS
    u_coins = completion.meta_data.find_by_key("coins") || completion.meta_data.build(:key => 'coins', :value => coins)
    u_best_coins = completion.meta_data.find_by_key("best_coins") || completion.meta_data.build(:key => 'best_coins', :value => coins)
    if coins.to_i > u_best_coins.value.to_i
      #this is the best coins
      current_user.add_coins(coins.to_i - u_best_coins.value.to_i)
      response[:add_coins] = response[:add_coins].to_i + (coins.to_i - u_best_coins.value.to_i)
      u_best_coins.value = coins.to_s
      u_best_coins.save unless u_best_coins.id.nil?
    end
    #TIME BONUS
    time_bonus = (((((level.bonus_time_limit / 1000.0) - time_taken) / 10).ceil) / (level.bonus_time_limit / 10000.0) * 10).round
    time_bonus = 0 if time_bonus < 0
    response[:time_bonus] = time_bonus
    #SCORE
    if level.possible_coins > 0
      score = ((1 - (coins.to_f / level.possible_coins)) * 50).round + (weighted_rotations * 2) + (locks * 5)
    else
      score = (weighted_rotations * 2) + (locks * 5)
    end
    score = score - time_bonus
    score = 1 if score < 1
    l_score = level.best_score
    old_top_scorers = level.top_scorers
    u_score = completion.meta_data.find_by_key("score") || completion.meta_data.build(:key => 'score', :value => score)
    response[:score] = score
    if u_score.value.to_i > score
      response[:score_personal_best] = 'true'
      current_user.add_coins(2)
      response[:add_coins] = response[:add_coins].to_i + 2
      u_score.value = score.to_s
      u_score.save unless u_score.id.nil?
      u_coins.value = coins.to_s
      u_coins.save unless u_coins.id.nil?
      u_locks.value = locks.to_s
      u_locks.save unless u_locks.id.nil?
      u_rotations.value = rotations.to_s
      u_rotations.save unless u_rotations.id.nil?
    end
    if (l_score.nil? || score < l_score)
      response[:score_best] = 'true'
      unless (old_top_scorers.length == 1 && old_top_scorers.include?(current_user))
        current_user.add_coins(10)
        response[:add_coins] = response[:add_coins].to_i + 10
      end
    end
    #SAVE Completion
    completion.save
    #record any coin transaction
    if response[:add_coins].to_i > 0
      current_user.coin_transactions.create!({:amount => response[:add_coins].to_i, :transaction_type => 'Level Reward', :note => "Reward for solving level #{level.number} of #{level.collection.name}"})
    end
    #send the ajax response
    ajax_response response
  end
  
  private
    def ajax_response(msg = {:type => "Empty", :code => 'Empty'})
      render :json => msg
    end
end
