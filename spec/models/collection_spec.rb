require 'spec_helper'

describe Collection do
  before(:each) do
    @attrs = { :number => 1, :name => 'Collection One' }
  end
  
  it "should create a new collection given valid attributes" do
    Collection.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a number" do
      bad_collection = Collection.new(@attrs.merge(:number => ''))
      bad_collection.should_not be_valid
    end
    
    it "should require a unique number" do
      Collection.create!(@attrs)
      bad_collection = Collection.new(@attrs.merge(:name => 'Different name same number'))
      bad_collection.should_not be_valid
    end
    
    it "should require a name" do
      bad_collection = Collection.new(@attrs.merge(:name => ''))
      bad_collection.should_not be_valid
    end
  end
end
