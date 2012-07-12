require 'spec_helper'

describe Unlock do
  before(:each) do
    @collection = Factory(:collection)
    @user = Factory(:user)
  end
  
  it "should create a new unlock for a user and collection" do
    @user.unlocks.create!(:collection => @collection)
  end
  
  describe "validations" do
    it "should require a collection" do
      bad_unlock = @user.unlocks.build()
      bad_unlock.should_not be_valid
    end
    
    it "should require a user" do
      bad_unlock = @collection.unlocks.build()
      bad_unlock.should_not be_valid
    end
    
    it "should require a unique collection and user combination" do
      @user.unlocks.create!(:collection => @collection)
      bad_unlock = @user.unlocks.build(:collection => @collection)
      bad_unlock.should_not be_valid
    end
    
    it "should allow users to have multple unlocked collections" do
      @user.unlocks.create!(:collection => @collection)
      good_unlock = @user.unlocks.build(:collection => Factory(:collection, :number => 2))
      good_unlock.should be_valid
    end
    
    it "should allow collections to have multple unlocked users" do
      @collection.unlocks.create!(:user => @user)
      good_unlock = @collection.unlocks.build(:user => Factory(:user, :fbid => '2'))
      good_unlock.should be_valid
    end
  end
  
end
