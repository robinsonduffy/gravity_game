class CreateCompletions < ActiveRecord::Migration
  def self.up
    create_table :completions do |t|
      t.integer :user_id
      t.integer :level_id
      t.timestamps
    end
    add_index :completions, :user_id
    add_index :completions, :level_id
    add_index :completions, [:user_id, :level_id], :unique => true
  end

  def self.down
    drop_table :completions
  end
end
