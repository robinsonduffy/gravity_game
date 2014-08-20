require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:username => "test_user", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
  end
  
  it "should create a new user given valid attributes" do
    User.create!(@attr)
  end
  
  describe "validations" do
    it "should require a username" do
      no_name_user = User.new(@attr.merge(:username => ' '))
      no_name_user.should_not be_valid
    end
    
    it "should require a unique username" do
      User.create!(@attr)
      same_name_user1 = User.new(@attr.merge(:username => 'test_user', :email => Factory.next(:email)))
      same_name_user1.should_not be_valid
      same_name_user2 = User.new(@attr.merge(:username => 'Test_User', :email => Factory.next(:email)))
      same_name_user2.should_not be_valid
    end
    
    it "should require username that are the right length" do
      short_name_user = User.new(@attr.merge(:username => "a"*3))
      short_name_user.should_not be_valid
      long_name_user = User.new(@attr.merge(:username => "a"*41))
      long_name_user.should_not be_valid
    end
    
    it "should require an email" do
      no_email_user = User.new(@attr.merge(:email => ' '))
      no_email_user.should_not be_valid
    end
    
    it "should require a password" do
      no_password_user = User.new(@attr.merge(:password => ' ', :password_confirmation => ' '))
      no_password_user.should_not be_valid
    end
    
    it "password confirmation must match password" do
      confirm_user = User.new(@attr.merge(:password_confirmation => 'boofar'))
      confirm_user.should_not be_valid
    end
    
    it "should require passwords that are the right length" do
      short_pass_user = User.new(@attr.merge(:password => "a"*3, :password_confirmation => "a"*3))
      short_pass_user.should_not be_valid
      long_pass_user = User.new(@attr.merge(:password => "a"*41, :password_confirmation => "a"*41))
      long_pass_user.should_not be_valid
    end
    
    it "should require a proper email address" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
  end
  
  describe "admin method" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should exist" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
end
