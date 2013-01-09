class LevelFactoryController < ApplicationController

  def new
    @title = "Level Factory"
    @level = Level.new(:collection_id => '0', :published => false, :grid_size => 4)
  end
end
