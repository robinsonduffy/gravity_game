require 'spec_helper'

describe LevelElement do
  before(:each) do
    @attrs = {:name => 'Test Element', :description => 'Test Element Description'}
  end

  it "should create a new level element given the correct attributes" do
    LevelElement.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_level_element = LevelElement.new(@attrs.merge(:name => '  '))
      bad_level_element.should_not be_valid
    end

    it "should require a unique name" do
      LevelElement.create!(@attrs)
      bad_level_element = LevelElement.new(@attrs.merge(:description => 'Different description, same name.'))
      bad_level_element.should_not be_valid
    end

    it "should require a description" do
      bad_level_element = LevelElement.new(@attrs.merge(:description => '  '))
      bad_level_element.should_not be_valid
    end
  end
end
