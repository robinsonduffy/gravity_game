class RemoveFbidFromUsers < ActiveRecord::Migration
  def self.up
    remove_index :users, column: :fbid
    remove_column :users, :fbid
  end

  def self.down
    add_column :users, :fbid, :string
    add_index :users, :fbid, :unique => true
  end
end
