require 'spec_helper'

describe ExtraAttribute do
  before(:each) do
    @attrs = {:key => '_color', :value => 'red'}
    @game_piece = Factory(:game_piece, :level => Factory(:level))
  end
  
  it "should create a new extra_attribute given valid attributes" do
    @game_piece.extra_attributes.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a key" do
      bad_extra_attribute = @game_piece.extra_attributes.build(@attrs.merge({:key => ''}))
      bad_extra_attribute.should_not be_valid
    end
    
    it "should require a value" do
      bad_extra_attribute = @game_piece.extra_attributes.build(@attrs.merge({:value => ''}))
      bad_extra_attribute.should_not be_valid
    end
    
    it "should require a unique key per game piece" do
      @game_piece.extra_attributes.create!(@attrs)
      bad_extra_attribute = @game_piece.extra_attributes.build(@attrs)
      bad_extra_attribute.should_not be_valid
    end
    
    it "should allow duplicate keys in different game pieces" do
      Factory(:extra_attribute, :game_piece => Factory(:game_piece, :level => Factory(:level)), :key => '_color')
      good_extra_attribute = @game_piece.extra_attributes.build(@attrs)
      good_extra_attribute.should be_valid
    end
    
    
  end
end
