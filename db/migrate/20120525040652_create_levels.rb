class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :levels do |t|
      t.integer :number
      t.integer :grid_size
      t.timestamps
    end
    add_index :levels, :number
  end

  def self.down
    drop_table :levels
  end
end
