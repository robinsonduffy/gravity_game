require 'spec_helper'

describe User do
  before(:each) do
    @attrs = {}
  end
  
  it "should create a new user given valid attributes" do
    User.create!(@attrs)
  end
  
  describe "validations" do
    
  end
  
  
end
