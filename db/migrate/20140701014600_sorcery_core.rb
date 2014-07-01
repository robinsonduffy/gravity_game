class SorceryCore < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string, :null => false
    add_column :users, :crypted_password, :string, :default => nil
    add_column :users, :salt, :string, :default => nil
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :crypted_password
    remove_column :users, :salt
  end
end