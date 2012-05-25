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
end
