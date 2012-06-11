class AjaxController < ApplicationController
  
  def complete_level
    if session[:fb_user_id] == params[:u]
      user = User.find_by_fbid(params[:u])
      ajax_response "There was an error (cl1)" and return if user.nil?
      level = Level.find_by_id(params[:l])
      ajax_response "There was an error (cl2)" and return if level.nil?
      if user.completed_levels.include?(level)
        #this user has already completed this level
        completion = user.completions.find_by_level_id(level)
        ajax_response 'You have already completed this level'
      else
        #this is the first time this user has completed this level
        completion = user.completions.create!({:level => level})
        ajax_response 'Good job'
      end
    else
      ajax_response "There was an error (cl3)" and return
    end
  end
  
  private
    def ajax_response(msg = '')
      render :text => msg
    end
end
