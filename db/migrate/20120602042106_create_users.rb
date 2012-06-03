class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :fbid
      t.timestamps
    end
    add_index :users, :fbid, :unique => true
  end

  def self.down
    drop_table :users
  end
end
