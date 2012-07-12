class CreateUnlocks < ActiveRecord::Migration
  def self.up
    create_table :unlocks do |t|
      t.integer :user_id
      t.integer :collection_id
      t.timestamps
    end
    add_index :unlocks, :user_id
    add_index :unlocks, :collection_id
    add_index :unlocks, [:user_id, :collection_id], :unique => true
  end

  def self.down
    drop_table :unlocks
  end
end
