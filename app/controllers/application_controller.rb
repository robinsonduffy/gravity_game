class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  
  before_filter :no_negative_coins
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
  
  def send_to_login_page
    #flash[:error] = "Please login"
    redirect_to login_path
  end
  
  def require_admin
    send_to_login_page if !current_user
    unless current_user.admin
      render :status => 403, :text => "Forbidden" and return
    end
  end
  
  def require_guest
    redirect_to root_path unless current_user.nil?
  end
  
  private
    
    def log_session
      logger.debug " "
      logger.debug "~~~"
      logger.debug session.inspect
      logger.debug "~~~"
      logger.debug " "
    end
    
    def no_negative_coins
      if(current_user && current_user.coins.to_i <= 0)
        current_user.coins = 0
        current_user.save
      end
    end
    
    def clear_current_level
      session[:current_level] = nil
    end
  
end
