class AddCoinCostToCollection < ActiveRecord::Migration
  def self.up
    add_column :collections, :coin_cost, :integer, :default => 0
  end

  def self.down
    remove_column :collections, :coin_cost
  end
end
