class CreateGamePieces < ActiveRecord::Migration
  def self.up
    create_table :game_pieces do |t|
      t.string :cell
      t.string :piece_type
      t.integer :level_id
      t.timestamps
    end
    add_index :game_pieces, :level_id
  end

  def self.down
    drop_table :game_pieces
  end
end
