require 'spec_helper'

describe CoinTransaction do
  before(:each) do
    @user = Factory(:user)
    @attrs = {:amount => 100, :transaction_type => 'Credit', :note => 'Purchased Coins'}
  end
  
  it "should create a new coin_transaction for a user given correct attributes" do
    @user.coin_transactions.create!(@attrs)
  end
  
  describe "validations" do
    it "should require an amount" do
      bad_transaction = @user.coin_transactions.build(@attrs.merge(:amount => ' '))
      bad_transaction.should_not be_valid
    end
    
    it "should require a numeric amount" do
      bad_transaction = @user.coin_transactions.build(@attrs.merge(:amount => 'ABCD'))
      bad_transaction.should_not be_valid
    end
    
    it "should require an integer amount" do
      bad_transaction = @user.coin_transactions.build(@attrs.merge(:amount => 1.7))
      bad_transaction.should_not be_valid
    end
    
    it "should allow a negative amount" do
      good_transaction = @user.coin_transactions.build(@attrs.merge(:amount => -100))
      good_transaction.should be_valid
    end
    
    it "should require a transation_type" do
      bad_transaction = @user.coin_transactions.build(@attrs.merge(:transaction_type => '  '))
      bad_transaction.should_not be_valid
    end
    
    it "should require a note" do
      bad_transaction = @user.coin_transactions.build(@attrs.merge(:note => '  '))
      bad_transaction.should_not be_valid
    end
  end
  
end
