class AjaxController < ApplicationController
  before_filter :require_current_user, :only => [:complete_level]
  
  def complete_level
    rotations = params[:r].to_i || 0
    ajax_response({:type => 'Error', :code => 'cl4'}) and return if rotations < 1
    level = Level.find_by_id(session[:current_level])
    ajax_response({:type => 'Error', :code => 'cl2'}) and return if level.nil?
    if current_user.completed_levels.include?(level)
      #this user has already completed this level
      completion = current_user.completions.find_by_level_id(level)
      response = {:type => 'Success', :first_time => 'false'}
    else
      #this is the first time this user has completed this level
      completion = current_user.completions.create!({:level => level})
      response = {:type => 'Success', :first_time => 'true'}
    end
    l_rotations = level.best_rotation
    u_rotations = completion.meta_data.find_by_key("rotations") || completion.meta_data.create!(:key => 'rotations', :value => rotations)
    if u_rotations.value.to_i > rotations
      response[:rotation_personal_best] = 'true'
      u_rotations.value = rotations.to_s
      u_rotations.save
    end
    response[:rotation_best] = 'true' if rotations < l_rotations
    #send the ajax response
    ajax_response response
  end
  
  private
    def ajax_response(msg = {:type => "Empty", :code => 'Empty'})
      render :json => msg
    end
end
