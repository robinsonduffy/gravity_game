class CreateExtraAttributes < ActiveRecord::Migration
  def self.up
    create_table :extra_attributes do |t|
      t.string :key
      t.string :value
      t.integer :game_piece_id
      t.timestamps
    end
    add_index :extra_attributes, :game_piece_id
  end

  def self.down
    drop_table :extra_attributes
  end
end
