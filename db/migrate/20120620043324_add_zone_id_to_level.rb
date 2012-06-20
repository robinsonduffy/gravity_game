class AddZoneIdToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :collection_id, :integer
    add_index :levels, :collection_id
  end

  def self.down
    remove_column :levels, :collection_id
    remove_index :levels, :collection_id
  end
end
