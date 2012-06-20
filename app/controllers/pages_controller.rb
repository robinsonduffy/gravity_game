class PagesController < ApplicationController
  
  before_filter :require_get, :only => [:home]
  before_filter :require_current_user, :only => [:home]
  before_filter :redirect_after_canvas_post, :only => [:home]
  before_filter :clear_current_level
  protect_from_forgery :except => [:home]
  
  def home
    @collections = Collection.order(:number)
  end
  
  def redirect_after_canvas_post
    if request.method == 'GET'
      unless session[:post_return_to].nil?
        redirect_to session[:post_return_to] and session[:post_return_to] = nil and return
      end
    end
  end
  
end
