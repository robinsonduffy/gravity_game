class AjaxController < ApplicationController
  before_filter :require_current_user, :only => [:complete_level]
  
  def complete_level
    rotations = params[:r].to_i || 0
    ajax_response({:type => 'Error', :code => 'CL4'}) and return if rotations < 1
    weighted_rotations = params[:w].to_i || 0
    ajax_response({:type => 'Error', :code => 'CL7'}) and return if weighted_rotations < 1
    ajax_response({:type => 'Error', :code => 'CL8'}) and return if weighted_rotations < rotations
    locks = params[:l].to_i || -1
    ajax_response({:type => 'Error', :code => 'CL5'}) and return if locks < 0
    coins = params[:c].to_i || -1
    ajax_response({:type => 'Error', :code => 'CL6'}) and return if coins < 0
    level = Level.find_by_id(session[:current_level])
    ajax_response({:type => 'Error', :code => 'CL2'}) and return if level.nil?
    time_taken = params[:t].to_i || 0
    ajax_response({:type => 'Error', :code => 'CL9'}) and return if time_taken < 1
    if current_user.completed_levels.include?(level)
      #this user has already completed this level
      completion = current_user.completions.find_by_level_id(level)
      response = {:type => 'Success', :first_time => 'false'}
    else
      #this is the first time this user has completed this level
      completion = current_user.completions.build({:level => level})
      response = {:type => 'Success', :first_time => 'true'}
    end
    #ROTATIONS
    #l_rotations = level.best_rotation
    u_rotations = completion.meta_data.find_by_key("rotations") || completion.meta_data.build(:key => 'rotations', :value => rotations)
    #LOCKS
    #l_locks = level.best_locked
    u_locks = completion.meta_data.find_by_key("locks") || completion.meta_data.build(:key => 'locks', :value => locks)
    #COINS
    #l_coins = level.best_coins
    u_coins = completion.meta_data.find_by_key("coins") || completion.meta_data.build(:key => 'coins', :value => coins)
    #TIME BONUS
    time_bonus = 0
    time_bonus = time_bonus + 1 if time_taken <= 60
    time_bonus = time_bonus + 1 if time_taken <= 50
    time_bonus = time_bonus + 1 if time_taken <= 40
    time_bonus = time_bonus + 1 if time_taken <= 30
    time_bonus = time_bonus + 1 if time_taken <= 20
    time_bonus = time_bonus + 1 if time_taken <= 10
    response[:time_bonus] = time_bonus
    #SCORE
    if level.possible_coins > 0
      score = ((1 - (coins / level.possible_coins)) * 50) + (weighted_rotations * 2) + (locks * 5)
    else
      score = (weighted_rotations * 2) + (locks * 5)
    end
    score = score - time_bonus
    score = 1 if score < 1
    l_score = level.best_score
    u_score = completion.meta_data.find_by_key("score") || completion.meta_data.build(:key => 'score', :value => score)
    response[:score] = score
    if u_score.value.to_i > score
      response[:score_personal_best] = 'true'
      u_score.value = score.to_s
      u_score.save unless u_score.id.nil?
      u_coins.value = coins.to_s
      u_coins.save unless u_coins.id.nil?
      u_locks.value = locks.to_s
      u_locks.save unless u_locks.id.nil?
      u_rotations.value = rotations.to_s
      u_rotations.save unless u_rotations.id.nil?
    end
    response[:score_best] = 'true' if (l_score.nil? || score < l_score)
    #SAVE Completion
    completion.save
    #send the ajax response
    ajax_response response
  end
  
  private
    def ajax_response(msg = {:type => "Empty", :code => 'Empty'})
      render :json => msg
    end
end
