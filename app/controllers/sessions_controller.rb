class SessionsController < ApplicationController
  
  def callback
    if(params[:error].nil?)
      session[:access_token] = authenticator.get_access_token(params[:code])
      redirect_back_or(fb_url(root_path))
    else
      redirect_to('http://www.facebook.com')
    end
  end
  
end
