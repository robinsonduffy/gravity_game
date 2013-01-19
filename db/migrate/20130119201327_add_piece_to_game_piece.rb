class AddPieceToGamePiece < ActiveRecord::Migration
  def self.up
    add_column :game_pieces, :piece, :string
  end

  def self.down
    remove_column :game_pieces, :piece
  end
end
