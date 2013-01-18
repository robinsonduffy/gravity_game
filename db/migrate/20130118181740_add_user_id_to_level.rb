class AddUserIdToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :user_id, :integer
    add_index :levels, :user_id
  end

  def self.down
    remove_indoex :levels, :user_id
    remove_column :levels, :user_id
  end
end
