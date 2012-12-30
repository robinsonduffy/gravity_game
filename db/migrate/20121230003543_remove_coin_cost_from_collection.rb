class RemoveCoinCostFromCollection < ActiveRecord::Migration
  def self.up
    remove_column :collections, :coin_cost
  end

  def self.down
    add_column :collections, :coin_cost, :integer, :default => 0
  end
end
