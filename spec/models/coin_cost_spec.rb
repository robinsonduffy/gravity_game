require 'spec_helper'

describe CoinCost do
  before(:each) do
    @collection = Factory(:collection)
    @attrs = {:value => 100}
  end

  it "should create a new coin cost given proper attributes" do
    @collection.create_coin_cost(@attrs)
  end

  describe "validations" do
    it "should require a value" do
      bad_coin_cost = @collection.build_coin_cost(@attrs.merge({:value => '  '}))
      bad_coin_cost.should_not be_valid
    end

    it "should require a positive value" do
      bad_coin_cost = @collection.build_coin_cost(@attrs.merge({:value => 0 }))
      bad_coin_cost.should_not be_valid
      bad_coin_cost = @collection.build_coin_cost(@attrs.merge({:value => -100 }))
      bad_coin_cost.should_not be_valid
    end

    it "should require an integer value" do
      bad_coin_cost = @collection.build_coin_cost(@attrs.merge({:value => 'a' }))
      bad_coin_cost.should_not be_valid
      bad_coin_cost = @collection.build_coin_cost(@attrs.merge({:value => 10.5 }))
      bad_coin_cost.should_not be_valid
    end
  end
end
