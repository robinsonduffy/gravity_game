class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Koala::Facebook::APIError, :with => :oath2_error
  before_filter :set_p3p
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
  
  def fb_url(path = '')
    "#{scheme}://apps.facebook.com/gravitygame#{path}"
  end
  
  def authenticator
    session[:oath] ||= Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"], url("#{fb_callback_path}"))
  end
  
  def fb_user
    graph.get_object('me')
  end
  
  def require_current_user
    @graph = Koala::Facebook::API.new(session[:access_token])
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
  
  private
    def oath2_error(e)
      logger.debug e
      login_to_facebook
    end
    
    def login_to_facebook
      store_location(fb_url(request.fullpath))
      session[:access_token] = nil
      render :text => "<script type='text/javascript'>parent.location.href='#{authenticator.url_for_oauth_code()}';</script>";
    end
    
    def set_p3p
      headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'
    end
    
    def log_session
      logger.debug " "
      logger.debug "~~~"
      logger.debug session.inspect
      logger.debug "~~~"
      logger.debug " "
    end
  
end
