require 'spec_helper'

describe Level do
  before(:each) do
    @attrs = { :number => 1 }
  end
  
  it "should create a new level given valid attributes" do
    Level.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a number" do
      bad_level = Level.new(:number => '')
      bad_level.should_not be_valid
    end
    
    it "should require a positive number" do
      bad_level = Level.new(:number => -1)
      bad_level.should_not be_valid
    end
    
    it "should require a numeric number" do
      bad_level = Level.new(:number => 'a')
      bad_level.should_not be_valid
    end
    
    it "should require an integer" do
      bad_level = Level.new(:number => 1.5)
      bad_level.should_not be_valid
    end
  end
end
