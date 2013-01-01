class ConvertUnlocksToPolymorphic < ActiveRecord::Migration
  def self.up
    remove_index :unlocks, [:user_id, :collection_id]
    remove_column :unlocks, :collection_id
    add_column :unlocks, :item_id, :integer
    add_column :unlocks, :item_type, :string
    add_index :unlocks, [:user_id, :item_id, :item_type], :unique => true
  end

  def self.down
    remove_index :unlocks, [:user_id, :item_id, :item_type]
    remove_column :unlocks, :item_type
    remove_column :unlocks, :item_id
    add_column :unlocks, :collection_id, :integer
    add_index :unlocks, [:user_id, :collection_id], :unique => true
  end
end
