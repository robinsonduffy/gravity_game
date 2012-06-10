require 'spec_helper'

describe MetaDatum do
  before(:each) do
    @level = Factory(:level)
    @attrs = {:key => 'hello', :value => 'dolly'}
  end
  
  it "should create a new meta_datum given proper attributes" do
    @level.meta_data.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a key" do
      bad_meta_data = @level.meta_data.build(@attrs.merge({:key => ''}))
      bad_meta_data.should_not be_valid
    end
    
    it "should require a value" do
      bad_meta_data = @level.meta_data.build(@attrs.merge({:value => ''}))
      bad_meta_data.should_not be_valid
    end
  end
  
end
