class PagesController < ApplicationController
  
  before_filter :require_login, :only => [:home]
  before_filter :clear_current_level
  
  def home
    @collections = Collection.order(:number)
  end
  
end
