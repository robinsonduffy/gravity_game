class AddGridSizeToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :grid_size, :integer
  end

  def self.down
    remove_column :levels, :grid_size
  end
end
