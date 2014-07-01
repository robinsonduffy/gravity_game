class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  
  before_filter :log_session
  
  def host
    request.env['HTTP_HOST']
  end

  def scheme
    request.scheme
  end

  def url_no_scheme(path = '')
    "//#{host}#{path}"
  end

  def url(path = '')
    "#{scheme}://#{host}#{path}"
  end
  
  def require_current_user
    if Rails.env == 'production'
      @graph = Koala::Facebook::API.new(session[:access_token])
      session[:fb_user_id] = (@graph.get_object('me'))["id"]
    else
      session[:fb_user_id] = 'abcde12345'
    end
    @game_user = User.find_by_fbid(session[:fb_user_id])
    if(@game_user.nil? && session[:fb_user_id].present? && !session[:fb_user_id].empty?)
      @game_user = User.create!({:fbid => session[:fb_user_id]})
    end
    if(@game_user.coins.to_i <= 0)
      @game_user.coins = 0
      @game_user.save
    end
  end
  
  def store_location(url = '')
    url.empty? ? session[:return_to] = fb_url(request.fullpath) : session[:return_to] = url
  end
  
  def clear_stored_location
    session[:return_to] = nil
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_stored_location
  end
  
  def javascript_redirect_back_or(default)
    redirect_url = session[:return_to] || default
    clear_stored_location
    render :text => "<script type='text/javascript'>parent.location.href='#{redirect_url}';</script>" and return
  end

  def page_not_found
    raise ActiveRecord::RecordNotFound
  end
  
  def access_denied
    flash[:error] = "You are not authorized to view that page"
    redirect_to login_path
  end
  
  private
    
    def log_session
      logger.debug " "
      logger.debug "~~~"
      logger.debug session.inspect
      logger.debug "~~~"
      logger.debug " "
    end
    
    def clear_current_level
      session[:current_level] = nil
    end
  
end
