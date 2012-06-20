require 'spec_helper'

describe Completion do
  before(:each) do
    @collection = Factory(:collection)
    @level = Factory(:level, :collection => @collection)
    @user = Factory(:user)
  end
  
  it "should create a new completion for a user and level" do
    @user.completions.create!(:level => @level)
  end
  
  describe "validations" do
    it "should require a level" do
      bad_completion = @user.completions.build()
      bad_completion.should_not be_valid
    end
    
    it "should require a user" do
      bad_completion = @level.completions.build()
      bad_completion.should_not be_valid
    end
    
    it "should require a unique level and user combination" do
      @user.completions.create!(:level => @level)
      bad_completion = @user.completions.build(:level => @level)
      bad_completion.should_not be_valid
    end
    
    it "should allow users to have multple levels" do
      @user.completions.create!(:level => @level)
      good_completion = @user.completions.build(:level => Factory(:level, :number => 2, :collection => @collection))
      good_completion.should be_valid
    end
    
    it "should allow levels to have multple users" do
      @level.completions.create!(:user => @user)
      good_completion = @level.completions.build(:user => Factory(:user, :fbid => '2'))
      good_completion.should be_valid
    end
  end
end
