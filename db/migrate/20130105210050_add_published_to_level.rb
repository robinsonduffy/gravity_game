class AddPublishedToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :published, :boolean, :default => false
  end

  def self.down
    remove_column :levels, :published
  end
end
