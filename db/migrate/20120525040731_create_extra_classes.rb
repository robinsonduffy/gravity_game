class CreateExtraClasses < ActiveRecord::Migration
  def self.up
    create_table :extra_classes do |t|
      t.string :class_name
      t.integer :game_piece_id
      t.timestamps
    end
    add_index :extra_classes, :game_piece_id
  end

  def self.down
    drop_table :extra_classes
  end
end
