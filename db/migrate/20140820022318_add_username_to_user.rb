class AddUsernameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :null => false
    add_index :users, :username, :unique => true
  end

  def self.down
    drop_index :users, :username
    drop_column :users, :username
  end
end
