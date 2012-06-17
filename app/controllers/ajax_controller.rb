class AjaxController < ApplicationController
  before_filter :require_current_user, :only => [:complete_level]
  
  def complete_level
    rotations = params[:r].to_i || 0
    ajax_response({:type => 'Error', :code => 'cl4'}) and return if rotations < 1
    locks = params[:l].to_i || -1
    ajax_response({:type => 'Error', :code => 'cl5'}) and return if locks < 0
    level = Level.find_by_id(session[:current_level])
    ajax_response({:type => 'Error', :code => 'cl2'}) and return if level.nil?
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
    l_rotations = level.best_rotation
    u_rotations = completion.meta_data.find_by_key("rotations") || completion.meta_data.build(:key => 'rotations', :value => rotations)
    if u_rotations.value.to_i > rotations
      response[:rotation_personal_best] = 'true'
      u_rotations.value = rotations.to_s
      u_rotations.save
    end
    response[:rotation_best] = 'true' if (l_rotations.nil? || rotations < l_rotations)
    #LOCKS
    l_locks = level.best_locked
    u_locks = u_rotations = completion.meta_data.find_by_key("locks") || completion.meta_data.build(:key => 'locks', :value => locks)
    if u_locks.value.to_i > locks
      response[:locks_personal_best] = 'true'
      u_locks.value = locks.to_s
      u_locks.save
    end
    response[:locks_best] = 'true' if (l_locks.nil? || locks < l_locks)
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
