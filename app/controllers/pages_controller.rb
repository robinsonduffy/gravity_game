class PagesController < ApplicationController
  
  before_filter :require_current_user, :only => [:home]
  protect_from_forgery :except => [:post_home]
  
  def home
    user = @graph.get_object('me')
    raise @game_user.inspect
  end
  
  def post_home
    redirect_to '/'
  end
  
end
