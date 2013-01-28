class AddNameAndDescriptionToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :name, :string
    add_column :levels, :description, :text
  end

  def self.down
    remove_column :levels, :description
    remove_column :levels, :name
  end
end
