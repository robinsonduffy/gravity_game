class PagesController < ApplicationController
  
  before_filter :require_get, :only => [:home]
  before_filter :require_current_user, :only => [:home]
  before_filter :redirect_after_canvas_post, :only => [:home]
  protect_from_forgery :except => [:home]
  
  def home
    user = @graph.get_object('me')
  end
  
  def redirect_after_canvas_post
    if request.method == 'GET'
      unless session[:post_return_to].nil?
        redirect_to session[:post_return_to] and session[:post_return_to] = nil and return
      end
    end
  end
  
end
