require 'spec_helper'

describe ExtraClass do
  before(:each) do
    @attrs = {:name => 'red'}
    @game_piece = Factory(:game_piece, :level => Factory(:level))
    
  end
  
  it "should create a new extra_class given valid attributes" do
    @game_piece.extra_classes.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a name" do
      bad_extra_class = @game_piece.extra_classes.build(@attrs.merge({:name => ''}))
      bad_extra_class.should_not be_valid
    end
    
    it "should require a unique name per game piece" do
      @game_piece.extra_classes.create!(@attrs)
      bad_extra_class = @game_piece.extra_classes.build(@attrs)
      bad_extra_class.should_not be_valid
    end
    
    it "should allow duplicate names in different game pieces" do
      Factory(:extra_class, :game_piece => Factory(:game_piece, :level => Factory(:level)), :name => 'red')
      good_extra_class = @game_piece.extra_classes.build(@attrs)
      good_extra_class.should be_valid
    end
    
    
  end
end
