require 'spec_helper'

describe User do
  before(:each) do
    @attrs = {:fbid => "100001258824080"}
  end
  
  it "should create a new user given valid attributes" do
    User.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a fbid" do
      bad_user = User.new(@attrs.merge({:fbid => ' '}))
      bad_user.should_not be_valid
    end
    
    it "should require a unique fbid" do
      User.create!(@attrs.merge({:fbid => '1234567890'}))
      bad_user = User.new(@attrs.merge({:fbid => '1234567890'}))
      bad_user.should_not be_valid
    end
  end
  
  
end
