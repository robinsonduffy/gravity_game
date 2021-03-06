require 'spec_helper'

describe Level do
  before(:each) do
    @attrs = { :number => 1, :grid_size => 4 }
  end
  
  it "should create a new level given valid attributes" do
    Level.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a number" do
      bad_level = Level.new(@attrs.merge(:number => ''))
      bad_level.should_not be_valid
    end
    
    it "should require a positive number" do
      bad_level = Level.new(@attrs.merge(:number => -1))
      bad_level.should_not be_valid
    end
    
    it "should require a numeric number" do
      bad_level = Level.new(@attrs.merge(:number => 'a'))
      bad_level.should_not be_valid
    end
    
    it "should require an integer" do
      bad_level = Level.new(@attrs.merge(:number => 1.5))
      bad_level.should_not be_valid
    end
    
    it "should require a grid_size" do
      bad_level = Level.new(@attrs.merge(:grid_size => ''))
      bad_level.should_not be_valid
    end
    
    it "should require a grid_size between 4 and 8" do
      bad_level = Level.new(@attrs.merge(:grid_size => 3))
      bad_level.should_not be_valid
      bad_level = Level.new(@attrs.merge(:grid_size => 9))
      bad_level.should_not be_valid
    end
    
    it "should require a numeric grid_size" do
      bad_level = Level.new(@attrs.merge(:grid_size => 'a'))
      bad_level.should_not be_valid
    end
    
    it "should require an integer grid_size" do
      bad_level = Level.new(@attrs.merge(:grid_size => 4.5))
      bad_level.should_not be_valid
    end
    
    it "should require a unique number per collection" do
      level = Level.create!(@attrs.merge(:collection => Factory(:collection)))
      bad_level = Level.new(@attrs.merge(:collection => level.collection))
      bad_level.should_not be_valid
    end
    
    it "should allow the same number in different collections" do
      collection1 = Factory(:collection, {:number => 1})
      collection2 = Factory(:collection, {:number => 2})
      level1 = Level.create!(@attrs.merge(:collection => collection1, :number => 1))
      level2 = Level.new(@attrs.merge(:collection => collection2, :number => 2))
      level1.should be_valid
      level2.should be_valid
    end
    
  end
end
