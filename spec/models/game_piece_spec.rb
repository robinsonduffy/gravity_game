require 'spec_helper'

describe GamePiece do
  before(:each) do
    @attrs = {:cell => '1,1', :piece_type => 'goal'}
    @level = Factory(:level)
  end
  
  it "should create a new game_piece given valid attributes" do
    @level.game_pieces.create!(@attrs)
  end
  
  describe "validations" do
    it "should require a cell" do
      bad_game_piece = @level.game_pieces.build(@attrs.merge({:cell => ''}))
      bad_game_piece.should_not be_valid
    end
    
    it "should require a piece_type" do
      bad_game_piece = @level.game_pieces.build(@attrs.merge({:piece_type => ''}))
      bad_game_piece.should_not be_valid
    end
    
  end
  
  describe "special methods" do
    before(:each) do
      @game_piece = @level.game_pieces.create!(@attrs)
      @game_piece.extra_classes.create!({:name => 'classA'})
      @game_piece.extra_classes.create!({:name => 'classB'})
      @game_piece.extra_attributes.create!({:key => '_attrA', :value => 'valueA'})
      @game_piece.extra_attributes.create!({:key => '_attrB', :value => 'valueB'})
      @game_piece.extra_attributes.create!({:key => '_attrC', :value => 'valueC'})
    end
    
    it "should have a class_hash method" do
      @game_piece.should respond_to(:class_hash)
    end
    
    it "should return the class_hash when called" do
      @game_piece.class_hash.should == {:class => ['goal', 'classA', 'classB']}
    end
    
    it "should have a attributes_hash method" do
      @game_piece.should respond_to(:attributes_hash)
    end
    
    it "should return the attributes_hash when called" do
      @game_piece.attributes_hash.should == {"_attrA" => 'valueA', "_attrB" => 'valueB', "_attrC" => 'valueC'}
    end
  end
end
