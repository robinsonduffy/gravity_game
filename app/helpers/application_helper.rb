module ApplicationHelper
  def title
    base_title = "Gravity Game"
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end
  
  def current_user
    @game_user ||= User.find_by_fbid(session[:fb_user_id])
  end
end